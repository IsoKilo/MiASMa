; ====================================================================================================
; int.asm
; Interrupt functions.

; Rachel Harrison
; 11/11/2025
; ====================================================================================================

	include	"md.lib"

; --------------------------------------------------

	section	.bss

	xdef	hint_jmp, hint_addr, hint_count
	xdef	vint_jmp, vint_addr, vint_count

hint_jmp:				ds.w 1
hint_addr:				ds.l 1
vint_jmp:				ds.w 1
vint_addr:				ds.l 1
hint_count:				ds.l 1
vint_count:				ds.l 1
	dseven

; --------------------------------------------------

	section .text

	xdef	int_init, vint_sync
	xdef	int_return
	xdef	int_start, int_end

int_init:
		lea		hint_jmp, a0			; Load interrupt instructions.
		move.w	#$4EF9, d0				; jmp op-code.
		move.l	#int_return, d1			; jmp address.
		move.w	d0, (a0)+
		move.l	d1, (a0)+
		move.w	d0, (a0)+
		move.l	d1, (a0)+
		rts

vint_sync:
		move	sr, -(sp)				; Store status register on the stack.
		move	#$2300, sr				; Enable interrupts.
		move.l	vint_count, d0			; Fetch current interrupt count.
@wait:
		cmp.l	vint_count, d0			; Has the count changed yet?
		beq.s	@wait					; If not, keep waiting until it triggers.
		move	(sp)+, sr				; Restore the status register.
		rts

int_return:
		rte

; Subroutine that every interrupt should run before doing anything.

int_start:
		push							; Store registers.
		z80_buson						; Grab the bus to stop it.
		z80_wait						; Make sure the request has been acknowledged.
		rts

; Subroutine that every interrupt should jump to after doing stuff.

int_end:
		addq.l	#1, vint_count			; Increment V-int counter.
		z80_busoff						; Release the bus.
		pop								; Restore registers.
		rte

; ====================================================================================================
	end
; ====================================================================================================