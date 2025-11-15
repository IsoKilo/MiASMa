; ====================================================================================================
; error.asm
; Error handler.

; Rachel Harrison
; 11/11/2025
; ====================================================================================================

	include	"md.lib"

; --------------------------------------------------

	section	.bss

	xref	STRING_NEWLINE
	xref	STRING_PALETTE0, STRING_PALETTE1, STRING_PALETTE2, STRING_PALETTE3
	xref	STRING_LOPRIORITY, STRING_HIPRIORITY
	xref	STRING_NOFLIP, STRING_HFLIP, STRING_VFLIP, STRING_HVFLIP
	xref	STRING_END

error_sp:				ds.l 1			; Stack pointer at time of crash.
error_sr:				ds.w 1			; Status register at time of crash.
error_pc:				ds.l 1			; ROM location at time of crash.
error_dest:				ds.l 1			; Attempted access address in bus/address errors.
error_rw:				ds.w 1			; Read/write on bus/address errors.
error_stack:			ds.b $100		; Stack minus information we already had.
error_aregs:			ds.l 7			; Address register addresses.
error_aregcontents:		ds.l 7			; Address register contents.
error_dregs:			ds.l 8			; Data register contents.
error_type:				ds.b 1			; Error exception type.
	dseven

; --------------------------------------------------

	section	.text

	xdef	error_bus
	xdef	error_address
	xdef	error_illegal
	xdef	error_zerodivide
	xdef	error_chk
	xdef	error_trapv
	xdef	error_privilege
	xdef	error_trace
	xdef	error_line1010
	xdef	error_line1111
	xdef	error_misc

error_bus:
		move.b	#1, error_type
		bra.w	error_init

error_address:
		move.b	#2, error_type
		bra.w	error_init

error_illegal:
		move.b	#3, error_type
		bra.w	error_init

error_zerodivide:
		move.b	#5, error_type
		bra.w	error_init

error_chk:
		move.b	#6, error_type
		bra.w	error_init

error_trapv:
		move.b	#7, error_type
		bra.w	error_init

error_privilege:
		move.b	#8, error_type
		bra.w	error_init

error_trace:
		move.b	#9, error_type
		bra.w	error_init

error_line1010:
		move.b	#10, error_type
		bra.w	error_init

error_line1111:
		move.b	#11, error_type
		bra.w	error_init

error_misc:
		move.b	#12, error_type
		bra.w	error_init

error_freeze:
		bra.s	error_freeze

error_init:
		movem.l	a0-a6, error_aregs	; Store address registers. We don't get a7 because that's just the stack.
		move.l	(a0), error_aregcontents+(0*LONG)	; Copy address register contents.
		move.l	(a1), error_aregcontents+(1*LONG)
		move.l	(a2), error_aregcontents+(2*LONG)
		move.l	(a3), error_aregcontents+(3*LONG)
		move.l	(a4), error_aregcontents+(4*LONG)
		move.l	(a5), error_aregcontents+(5*LONG)
		move.l	(a6), error_aregcontents+(6*LONG)
		movem.l	d0-d7, error_dregs	; Store data registers.
		move.l	sp, error_sp		; Store the stack pointer address.
		cmpi.b	#2, error_type		; Is this a bus error or address error?
		bls.s	@busaddress			; If so, we have to get our info off the stack differently.
		move.w	0(sp), error_sr		; Get status register at time of crash.
		move.l	2(sp), error_pc		; Get address.

@busaddress:
		move.w	0(sp), error_rw		; Get read/write flag.
		move.l	2(sp), error_dest	; Get accessed address.
		move.w	8(sp), error_sr		; Get status register at time of crash.

@cont:
		ori.w	#$700, sr			; Disable interrupts.
		rts

error_loop:
		bra.s	error_loop

errortext_header:
		dc.b	STRING_PALETTE3, "MiASMa Error Handler", STRING_END
		even

errortext_footer:
		dc.b	STRING_PALETTE2, "V0.1 ", STRING_PALETTE0, "14/11/2025 ", STRING_PALETTE1 "(C) Rachel Harrison", STRING_END
		even

errortext_types:
		dc.b	STRING_PALETTE1, "Bus error "
		dc.b	STRING_PALETTE1, "Address error "
		dc.b	STRING_PALETTE1, "Illegal instruction "
		dc.b	STRING_PALETTE1, "Divide by zero "
		dc.b	STRING_PALETTE1, "CHK out of bounds "
		even

; ====================================================================================================
	end
; ====================================================================================================