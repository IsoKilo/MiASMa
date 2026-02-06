; ====================================================================================================
; FILE:			error.s
; DESCRIPTION:	Error handler.
; DATE:			05/02/2026
; AUTHOR:		Rachel Harrison
; ====================================================================================================

	include	"src/megadrive.inc"
	include	"src/miasma.inc"
	include	"src/consts.inc"

; --------------------------------------------------

	section	code

	xdef	error_bus, error_address, error_illegal
	xdef	error_zerodiv, error_chk, error_trapv
	xdef	error_privviol, error_trace, error_lineaemu
	xdef	error_linefemu, error_misc, error_checksum

error_bus:
error_address:
error_illegal:
error_zerodiv:
error_chk:
error_trapv:
error_privviol:
error_trace:
error_lineaemu:
error_linefemu:
error_misc:
error_checksum:
error_freeze:
		bra.b	error_freeze

; ====================================================================================================
	end
; ====================================================================================================