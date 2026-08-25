; ====================================================================================================
; FILE:		header.asm
; DESCRIPTION:	68k exception vectors and Mega Drive ROM header.
; DATE:		24/08/2026
; AUTHOR:	Rachel "Kilo" Harrison
; ====================================================================================================

; Includes
	nolist
	include	"megadrive.inc"
	include	"config.inc"
	list
	include	"main.inc"
	include	"header.inc"

; ====================================================================================================

	section	.bss

sys_stack:	ds.b	$100						; System stack.
sys_stackptr:	ds.w	0						; Stack pointer.
	dseven

; ====================================================================================================

	section	.header

HEADER_START:
HEADER_EXCEPTIONS:
		dc.l	sys_stackptr&$FFFFFF				; Initial stack pointer.
		dc.l	Main						; Initial program counter.
	rept 62
		dc.l	Main
	endr

HEADER_SYSTEM:
		dc.b	"SEGA "						; SEGA must be present here for TMSS.
	if OPT_MAPPER=false
	if (BUILD_JP=true)|(BUILD_EU=true)
		dc.b	"MEGA DRIVE"
	else
		dc.b	"GENESIS"					; Use Genesis name for US only builds.
	endif
	else
		dc.b	"SSF"						; Ensure mapper support on EverDrive.
	endif
.pad:
		dcb.b	16-(.pad-HEADER_SYSTEM), " "			; Pad to 16 bytes.

HEADER_COPYRIGHT:
		dc.b	"(C)\GAME_DEV\"					; Copyright and dev name.
.pad:
		dcb.b	8-(.pad-HEADER_COPYRIGHT), " "			; Pad game dev name.
		dc.b	"\#BUILD_YEAR\.\BUILD_MONTH\"			; Build time.

HEADER_TITLE:
HEADER_TITLEDOM:
	if OPT_MAPPER=false
		dc.b	"\GAME_TITLE\"					; Domestic game title.
	else
		dc.b	"SUPER STREET FIGHTER2 The New Challengers"	; Ensure mapper compatibility on emulators.
	endif
.pad:
		dcb.b	48-(.pad-HEADER_TITLEDOM), " "			; Pad to 48 bytes.

HEADER_TITLEINT:
	if OPT_MAPPER=false
		dc.b	"\GAME_TITLE\"					; Overseas game title.
	else
		dc.b	"SUPER STREET FIGHTER2 The New Challengers"	; Ensure mapper compatibility on emulators.
	endif
.pad:
		dcb.b	48-(.pad-HEADER_TITLEINT), " "			; Pad to 48 bytes.

HEADER_SERIAL:
		dc.b	"GM 00000000-00"				; Serial and revision number, 14 bytes.

HEADER_CHECKSUM:
		dc.w	$0000						; ROM checksum, patched at build time.

HEADER_DEVICES:
	if DEVICE_3BTN=true
		dc.b	"J"						; 3-button joypad support.
	endif
	if DEVICE_6BTN=true
		dc.b	"6"						; 6-button joypad support.
	endif
	if DEVICE_SMS=true
		dc.b	"0"						; Master System joypad support.
	endif
	if DEVICE_XE1AP=true
		dc.b	"A"						; XE-1 AP analog joypad support.
	endif
	if (DEVICE_TEAM=true)|(DEVICE_4WAY=true)
		dc.b	"4"						; Multi-tap support.
	endif
	if (DEVICE_MENACER=true)|(DEVICE_JUSTIFER=true)
		dc.b	"G"						; Light-gun support.
	endif
	if DEVICE_MOUSE=true
		dc.b	"M"						; SEGA mouse support.
	endif
	if DEVICE_BALL=true
		dc.b	"B"						; Master System Sports Pad trackball joypad support.
	endif
	if DEVICE_PADDLE=true
		dc.b	"V"						; Master System MK3 paddle controller support.
	endif
	if (DEVICE_KEYBOARD=true)|(DEVICE_KEYPAD=true)
		dc.b	"K"						; Keyboard/keypad support.
	endif
	if DEVICE_PRINTER=true
		dc.b	"P"						; Mega Anser printer support.
	endif
.pad:
		dcb.b	16-(.pad-HEADER_DEVICES), " "			; Pad to 16 bytes.

HEADER_ROMRANGE:
HEADER_ROMSTART:
		dc.l	ROM_START					; ROM start address.

HEADER_ROMEND:
		dc.l	ROM_END-1					; ROM end address.

HEADER_RAMRANGE:
HEADER_RAMSTART:
		dc.l	RAM_START					; RAM start address.

HEADER_RAMEND:
		dc.l	RAM_END-1					; RAM end address.

	if OPT_SRAM=true
HEADER_SRAM:
		dc.b	"RA", $A0|SRAM_TYPE|SRAM_ALIGN, $20		; SRAM support.

HEADER_SRAMRANGE:
HEADER_SRAMSTART:
		dc.l	SRAM_START					; SRAM start address.

HEADER_SRAMEND:
		dc.l	SRAM_END-1					; SRAM end address.
	else
HEADER_SRAM:
		dc.b	"    "						; SRAM support.

HEADER_SRAMRANGE:
HEADER_SRAMSTART:
		dc.b	"    "						; SRAM start address.

HEADER_SRAMEND:
		dc.b	"    "						; SRAM end address.
	endif

HEADER_MODEM:
		dc.b	"            "

HEADER_NOTES:
		dc.b	"MiASMa Engine Version 0.0.0"			; Misc. notes.
.pad:
		dcb.b	40-(.pad-HEADER_NOTES), " "			; Pad to 40 bytes.

HEADER_REGIONS:
	if BUILD_JP=true
		dc.b	"J"						; Japanese sytem support.
	endif
	if BUILD_US=true
		dc.b	"U"						; US system support.
	endif
	if BUILD_EU=true
		dc.b	"E"						; European system support.
	endif
.pad:
		dcb.b	16-(.pad-HEADER_REGIONS), " "			; Pad to 16 bytes.

HEADER_END:
	if ~(HEADER_END-HEADER_START)=$200
	inform	3, "Header is incorrectly sized, expected size is $200, actual size is $%h", (HEADER_END-HEADER_START)
	endif

; ====================================================================================================

	end

; ====================================================================================================
; End of file
; ====================================================================================================