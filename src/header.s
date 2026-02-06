; ====================================================================================================
; FILE:			header.s
; DESCRIPTION:	68K exception vectors and Mega Drive ROM header.
; DATE:			05/02/2026
; AUTHOR:		Rachel Harrison
; ====================================================================================================

	include	"src/megadrive.inc"
	include	"src/miasma.inc"
	include	"src/consts.inc"

; --------------------------------------------------

	section	ram

	xdef		sys_stack, sys_stackptr

sys_stack:		ds.b $100
sys_stackptr:	ds.w 1

; --------------------------------------------------

	section	code

	xref		main, hint, vint
	xref		error_bus, error_address, error_illegal
	xref		error_zerodiv, error_chk, error_trapv
	xref		error_privviol, error_trace, error_lineaemu
	xref		error_linefemu, error_misc

	xdef		header_exceptions
	xdef		header_system, header_copyright
	xdef		header_titledom, header_titleint
	xdef		header_serial, header_checksum
	xdef		header_devices
	xdef		header_romrange, header_ramrange
	xdef		header_sramtype, header_sramrange
	xdef		header_modemtype, header_notes, header_regions
	xdef		header_end

header_exceptions:
		dc.l	sys_stackptr&U24_MAX
		dc.l	main
		dc.l	error_bus
		dc.l	error_address
		dc.l	error_illegal
		dc.l	error_zerodiv
		dc.l	error_chk
		dc.l	error_trapv
		dc.l	error_privviol
		dc.l	error_trace
		dc.l	error_lineaemu
		dc.l	error_linefemu
		dc.l	error_misc
		dc.l	error_misc
		dc.l	error_misc
		dc.l	error_misc
		dc.l	error_misc
		dc.l	error_misc
		dc.l	error_misc
		dc.l	error_misc
		dc.l	error_misc
		dc.l	error_misc
		dc.l	error_misc
		dc.l	error_misc
		dc.l	error_misc
		dc.l	error_misc
		dc.l	error_misc
		dc.l	error_misc
		dc.l	hint
		dc.l	error_misc
		dc.l	vint
		dc.l	error_misc
		dc.l	error_misc
		dc.l	error_misc
		dc.l	error_misc
		dc.l	error_misc
		dc.l	error_misc
		dc.l	error_misc
		dc.l	error_misc
		dc.l	error_misc
		dc.l	error_misc
		dc.l	error_misc
		dc.l	error_misc
		dc.l	error_misc
		dc.l	error_misc
		dc.l	error_misc
		dc.l	error_misc
		dc.l	error_misc
		dc.l	error_misc
		dc.l	error_misc
		dc.l	error_misc
		dc.l	error_misc
		dc.l	error_misc
		dc.l	error_misc
		dc.l	error_misc
		dc.l	error_misc
		dc.l	error_misc
		dc.l	error_misc
		dc.l	error_misc
		dc.l	error_misc
		dc.l	error_misc
		dc.l	error_misc
		dc.l	error_misc
		dc.l	error_misc
header_system:
		dc.b	"SEGA MEGA DRIVE "
header_copyright:
		dc.b	"(C)\GAME_DEV\ \#BUILD_YEAR\.\BUILD_MONTH\"
header_titledom:
		dc.b	"\GAME_TITLEDOM\"
header_titleint:
		dc.b	"\GAME_TITLEINT\"
header_serial:
		dc.b	"GM 00000000-00"
header_checksum:
		dc.w	$0000
header_devices:
		dc.b	"J               "
header_romrange:
		dc.l	rom_start, $\$GAME_SIZE\-1
header_ramrange:
		dc.l	ram_start, ram_end-1
header_sramtype:
	if ENABLE_SRAM=TRUE
	if ENABLE_SAVE=TRUE
		dc.b	"RA", $F8, " "	; Enable 8-bit odd address saving.
	else
		dc.b	"RA", $B8, " "	; Enable 8-bit odd address SRAM.
	endif
	else
		dc.b	"    "			; No SRAM.
	endif
header_sramrange:
	if ENABLE_SRAM=TRUE
		dc.l	sram_start, sram_end-1
	else
		dc.b	"        "
	endif
header_modemtype:
		dc.b	"MO\GAME_DEV\00.000"
header_notes:
		dc.b	"MIASMA ENGINE VERSION 0.0.0             "
header_regions:
		dc.b	"JUE             "
header_end:

; ====================================================================================================
	end
; ====================================================================================================