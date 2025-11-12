; ====================================================================================================
; header.asm
; Motorola 68000 vector table and SEGA Mega Drive ROM header.

; Rachel Harrison
; 11/11/2025
; ====================================================================================================

	include	"md.lib"

; --------------------------------------------------

	section	.bss

	xdef	cpu_stack, cpu_sp

	xref	hint_jmp, vint_jmp

cpu_stack:				ds.b	$100
cpu_sp:					ds.w	1
	dseven

; --------------------------------------------------

	section	.text

	xdef	header_vectors
	xdef	header_systemtype, header_copyright
	xdef	header_titledomestic, header_titleinternational
	xdef	header_serial, header_checksum, header_devicetype
	xdef	header_romrange, header_ramrange
	xdef	header_sramtype, header_sramrange
	xdef	header_modemtype, header_notes, header_regiontype
	xdef	header_end

	xref	main
	xref	error_bus, error_address, error_illegal
	xref	error_zerodivide, error_chk, error_trapv
	xref	error_privilege, error_trace, error_line1010, error_line1111
	xref	error_misc

header_vectors:
		dc.l	cpu_sp&$FFFFFF
		dc.l	main
		dc.l	error_bus
		dc.l	error_address
		dc.l	error_illegal
		dc.l	error_zerodivide
		dc.l	error_chk
		dc.l	error_trapv
		dc.l	error_privilege
		dc.l	error_trace
		dc.l	error_line1010
		dc.l	error_line1111
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
		dc.l	hint_jmp
		dc.l	error_misc
		dc.l	vint_jmp
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

header_systemtype:
		dc.b	"SEGA MEGA DRIVE "

header_copyright:
		dc.b	"(C)NAME 2026.JAN"

header_titledomestic:
		dc.b	"My MiASMa Engine Project (Domestic)             "

header_titleinternational:
		dc.b	"My MiASMa Engine Project (International)        "

header_serial:
		dc.b	"GM 00000000-00"

header_checksum:
		dc.w	$0000

header_devicetype:
		dc.b	"J6              "

header_romrange:
		dc.l	rom_start, rom_end-1

header_ramrange:
		dc.l	ram_start, ram_end-1

header_sramtype:
		dc.b	"RA", $B0, $20

header_sramrange:
		dc.l	sram_start, sram_end-1

header_modemtype:
		dc.b	"MONAMEXX,000"

header_notes:
		dc.b	"                                        "

header_regiontype:
		dc.b	"JUE             "

header_end:

; ====================================================================================================
	end
; ====================================================================================================