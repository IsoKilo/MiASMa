; ====================================================================================================
; FILE:		string.inc
; DESCRIPTION:	Exports/imports, constants, and macros for string.asm.
; DATE:		24/08/2026
; AUTHOR:	Rachel "Kilo" Harrison
; ====================================================================================================

; Define once
	if ~def(__STRING__)
__STRING__ = 0

; ====================================================================================================

; Font constants
FONT_TILE:		equ $000				; Starting tile ID of font.
FONT_START:		equ " "					; Starting character of font.
FONT_END:		equ "~"					; Ending character of font.

; String codes
	rsset	-2
STRCODE_END:		rs.w -1					; End string rendering.
STRCODE_NEWLINE:	rs.w -1					; Draw a new line.
STRCODE_RESET:		rs.w -1					; Reset rendering flags.
STRCODE_NOFLIP:		rs.w -1					; Disable horizontal/vertical flipping.
STRCODE_HFLIP:		rs.w -1					; Horizontally flip the font.
STRCODE_VFLIP:		rs.w -1					; Vertically flip the font.
STRCODE_HVFLIP:		rs.w -1					; Horizontally and vertically flip the font.
STRCODE_PAL1:		rs.w -1					; Set font palette line to 1.
STRCODE_PAL2:		rs.w -1					; Set font palette line to 2.
STRCODE_PAL3:		rs.w -1					; Set font palette line to 3.
STRCODE_PAL4:		rs.w -1					; Set font palette line to 4.
STRCODE_LOPRI:		rs.w -1					; Set font to low priority.
STRCODE_HIPRI:		rs.w -1					; Set font to high priority.
STRCODE_SPECIAL:	rs.w -1					; Draw a specified tile ID for special icons.

; ====================================================================================================

	global	String_LoadFont
	global	String_DrawPlane, String_DrawVRAM		; Standard string drawing functions.

; ====================================================================================================

stringplane:	macro	src, addr				; Simplifies setting up a call to String_DrawPlane.
		vdp_cmd	VRAM, WRITE, \addr, d7
		lea	\src, a5
		bsr.w	String_DrawPlane
	endm

stringvram:	macro	src, addr				; Simplifies setting up a call to String_DrawVRAM.
		vdp_cmd	VRAM, WRITE, \addr
		lea	\src, a5
		bsr.w	String_DrawVRAM
	endm

; ====================================================================================================

	endif

; ====================================================================================================
; End of file
; ====================================================================================================