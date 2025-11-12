; ====================================================================================================
; error.asm
; Error handler.

; Rachel Harrison
; 11/11/2025
; ====================================================================================================

	include	"md.lib"

; --------------------------------------------------

	xref	STRING_NEWLINE
	xref	STRING_PALETTE0, STRING_PALETTE1, STRING_PALETTE2, STRING_PALETTE3
	xref	STRING_LOPRIORITY, STRING_HIPRIORITY
	xref	STRING_NOFLIP, STRING_HFLIP, STRING_VFLIP, STRING_HVFLIP
	xref	STRING_END

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

error_address:

error_illegal:

error_zerodivide:

error_chk:

error_trapv:

error_privilege:

error_trace:

error_line1010:

error_line1111:

error_misc:

error_freeze:
		bra.s	error_freeze

error_texttbl:

bus_text:

address_text:

illegal_text:

; ====================================================================================================
	end
; ====================================================================================================