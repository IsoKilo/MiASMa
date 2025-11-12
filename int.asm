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

int_init:
		lea		hint_jmp, a0		; Load interrupt instructions.
		move.w	#$4EF9, d0			; jmp op-code.
		move.l	#int_return, d1		; jmp address.
		move.w	d0, (a0)+
		move.l	d1, (a0)+
		move.w	d0, (a0)+
		move.l	d1, (a0)+
		rts

vint_sync:
		move.w	sr, -(sp)			; Store status register on the stack.
		move.w	#$2300, sr			; Enable interrupts.
		move.l	vint_count, d0		; Fetch current interrupt count.
@wait:
		cmp.l	vint_count, d0		; Has the count changed yet?
		beq.s	@wait				; If not, keep waiting until it triggers.
		move.w	(sp)+, sr			; Restore the status register.
		rts

int_return:
		rte

; ====================================================================================================
	end
; ====================================================================================================