; ====================================================================================================
; FILE:			ints.s
; DESCRIPTION:	Interrupt functions and handlers.
; DATE:			05/02/2026
; AUTHOR:		Rachel Harrison
; ====================================================================================================

	include	"src/megadrive.inc"
	include	"src/miasma.inc"
	include	"src/consts.inc"

; --------------------------------------------------

	section	ram

	xdef	vint_count

vint_count:	ds.l 1

; --------------------------------------------------

	section	code

	xdef	vint_sync, vint, hint

vint_sync:
		int_enable				; Make sure interrupts are enabled so we don't lock up.
		move.l	vint_count, d7	; Get current V-int count.
@wait:
		cmp.l	vint_count, d7	; Is the V-int count still the same?
		beq.b	@wait			; If so, loop until it changes.
		rts

vint:
		push
		addq.l	#1, vint_count
		pop
		rte

hint:
		rte

; ====================================================================================================
	end
; ====================================================================================================