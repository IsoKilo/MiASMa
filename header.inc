; ====================================================================================================
; FILE:		header.inc
; DESCRIPTION:	Exports/imports, constants, and macros for header.asm.
; DATE:		24/08/2026
; AUTHOR:	Rachel "Kilo" Harrison
; ====================================================================================================

; Define once
	if ~def(__HEADER__)
__HEADER__ = 0

; ====================================================================================================

	global	sys_stack, sys_stackptr				; System stack.

; ====================================================================================================

	global	HEADER_START, HEADER_END
	global	HEADER_EXCEPTIONS, HEADER_SYSTEM, HEADER_COPYRIGHT
	global	HEADER_TITLE, HEADER_TITLEDOM, HEADER_TITLEINT
	global	HEADER_SERIAL, HEADER_CHECKSUM, HEADER_DEVICES
	global	HEADER_ROMRANGE, HEADER_ROMSTART, HEADER_ROMEND
	global	HEADER_RAMRANGE, HEADER_RAMSTART, HEADER_RAMEND
	global	HEADER_SRAM, HEADER_SRAMRANGE, HEADER_SRAMSTART, HEADER_SRAMEND
	global	HEADER_MODEM, HEADER_NOTES, HEADER_REGIONS

; ====================================================================================================

	endif

; ====================================================================================================
; End of file
; ====================================================================================================