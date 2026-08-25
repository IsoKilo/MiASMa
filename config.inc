; ====================================================================================================
; FILE:		config.inc
; DESCRIPTION:	MiASMa Engine configuration flags.
; DATE:		24/08/2026
; AUTHOR:	Rachel "Kilo" Harrison
; ====================================================================================================

; Define once
	if ~def(__CONFIG__)
__CONFIG__ = 0

; ====================================================================================================

; --------------------------------------------------
; Build flags
; --------------------------------------------------

; Build types
BUILD_TYPE:		equ BUILD_DEBUG

	rsreset
BUILD_DEBUG:		rs.b 1					; Development/debugging build.
BUILD_RELEASE:		rs.b 1					; Final release build.
BUILD_DEMO:		rs.b 1					; Demo/special build.

; Build regions
BUILD_JP:		equ true				; Build for Japanese systems.
BUILD_US:		equ true				; Build for US systems.
BUILD_EU:		equ true				; Build for European systems.

; Build time
BUILD_YEAR:		equ _year+1900
BUILD_MONTH:		substr ((_month-1)*3)+1,((_month-1)*3)+3,"JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC"
BUILD_DAY:		equ _day
BUILD_HOUR:		equ _hours
BUILD_MIN:		equ _minutes
BUILD_SEC:		equ _seconds

; --------------------------------------------------

; --------------------------------------------------
; Game info
; --------------------------------------------------

GAME_TITLE:		equs "My MiASMa Engine Project"		; Game title. 48 characters max.
GAME_DEV:		equs "NAME"				; Game developer name. 4 characters max.

; --------------------------------------------------

; --------------------------------------------------
; Engine options
; --------------------------------------------------

OPT_SRAM:		equ false				; Enable SRAM support.
OPT_MAPPER:		equ false				; Enable ROM mapper support.
OPT_MODEM:		equ false				; Enable Mega Modem support.
OPT_REGLOCK:		equ false				; Enable region lockout.
OPT_3D:			equ false				; Enables 3D sprite support. Uses extra RAM and CPU usage, does not effect maps.

; --------------------------------------------------

; --------------------------------------------------
; Device support
; --------------------------------------------------

DEVICE_3BTN:		equ true				; Enable 3-button joypad support.
DEVICE_6BTN:		equ false				; Enable 6-button joypad support.
DEVICE_SMS:		equ false				; Enable Master System joypad support.
DEVICE_XE1AP:		equ false				; Enable XE-1 AP analog joypad support.
DEVICE_TEAM:		equ false				; Enable SEGA Team Player multi-tap support.
DEVICE_4WAY:		equ false				; Enable EA 4-Way Play multi-tap support.
DEVICE_MENACER:		equ false				; Enable SEGA Menacer light-gun support.
DEVICE_JUSTIFER:	equ false				; Enable Konami Justifier light-gun support.
DEVICE_MOUSE:		equ false				; Enable SEGA mouse support.
DEVICE_BALL:		equ false				; Enable Master System Sports Pad trackball joypad support.
DEVICE_PADDLE:		equ false				; Enable Master System MK3 paddle controller support.
DEVICE_KEYBOARD:	equ false				; Enable XBAND keyboard support.
DEVICE_KEYPAD:		equ false				; Enable Mega Anser keypad support.
DEVICE_PRINTER:		equ false				; Enable Mega Anser printer support.

; --------------------------------------------------

; ====================================================================================================

	endif

; ====================================================================================================
; End of file
; ====================================================================================================