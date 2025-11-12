; ====================================================================================================
; error.asm
; Error handler.

; Rachel Harrison
; 11/11/2025
; ====================================================================================================

	include	"md.lib"

; --------------------------------------------------

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
	xdef	error_freeze

error_bus:
error_address:
error_illegal:
error_zerodivide:
error_chk:
error_trapv:
error_privilege:
error_trace:
error_line1010:
error_line1111:
error_freeze:
		bra.s	error_freeze

; ====================================================================================================
	end
; ====================================================================================================