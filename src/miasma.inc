; ====================================================================================================
; FILE:			miasma.inc
; DESCRIPTION:	Engine settings and info.
; DATE:			05/02/2026
; AUTHOR:		Rachel Harrison
; ====================================================================================================

; --------------------------------------------------
; Build time
; --------------------------------------------------

BUILD_YEAR:		equ _year+1900
BUILD_MONTH:	substr ((_month-1)*3)+1,((_month-1)*3)+3,"JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC"
BUILD_DAY:		equ _day
BUILD_HOUR:		equ _hours
BUILD_MIN:		equ _minutes
BUILD_SEC:		equ _seconds

; --------------------------------------------------

; --------------------------------------------------
; Game info
; --------------------------------------------------

GAME_DEV:		equs "NAME"												; Must be 4 characters.
GAME_TITLEDOM:	equs "My MiASMa Engine Project (Domestic)             "	; Must be 48 characters.
GAME_TITLEINT:	equs "My MiASMa Engine Project (International)        "	; Must be 48 characters.
GAME_SIZE:		equ rom_128kb											; ROM size.

ENABLE_SRAM:	equ FALSE	; Enables SRAM.
ENABLE_SAVE:	equ FALSE	; Enables saving with SRAM.

; --------------------------------------------------

; ====================================================================================================
; End
; ====================================================================================================