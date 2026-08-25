; ====================================================================================================
; FILE:		vdp.inc
; DESCRIPTION:	Exports/imports, constants, and macros for vdp.asm.
; DATE:		24/08/2026
; AUTHOR:	Rachel "Kilo" Harrison
; ====================================================================================================

; Define once
	if ~def(__VDP__)
__VDP__ = 0

; ====================================================================================================

	global	vdp_regbuffer					; VDP register buffer, to allow for reading VDP registers. SMS and 128KB VRAM registers have been excluded.

; ====================================================================================================

; VDP register buffer offsets
	rsreset
VRBUFF_MODE1:		rs.w 1					; VDP mode 1 options register.
VRBUFF_MODE2:		rs.w 1					; VDP mode 2 options register.
VRBUFF_PLNAADDR:	rs.w 1					; Plane A nametable VRAM address.
VRBUFF_WINADDR:		rs.w 1					; Window nametable VRAM address.
VRBUFF_PLNBADDR:	rs.w 1					; Plane B nametable VRAM address.
VRBUFF_SPRADDR:		rs.w 1					; Sprite table VRAM address.
VRBUFF_BGCOLOR:		rs.w 1					; Background color palette index.
VRBUFF_HINTRATE:	rs.w 1					; Horizontal interrupt scan-line rate.
VRBUFF_MODE3:		rs.w 1					; VDP mode 3 options register.
VRBUFF_MODE4:		rs.w 1					; VDP mode 4 options register.
VRBUFF_HSCRADDR:	rs.w 1					; Horizontal scroll table VRAM address.
VRBUFF_AUTOINC:		rs.w 1					; VDP read/write address auto-increment width.
VRBUFF_PLNSIZE:		rs.w 1					; Plane map size.
VRBUFF_WINXPOS:		rs.w 1					; Window plane X position.
VRBUFF_WINYPOS:		rs.w 1					; Window plane Y position.
VRBUFF_END:		rs.b 0

; ====================================================================================================

	global	VDP_Init					; Initializes the VDP entirely.
	global	VDP_UpdateRegs					; Updates VDP registers with those in the buffer.
	global	VDP_VRAMClear, VDP_CRAMClear, VDP_VSRAMClear	; Clearing functions.
	global	VDP_DrawTile, VDP_DrawTilemap			; Drawing functions.

; ====================================================================================================

drawtile:	macro	src, addr, len				; Simplifies setting up a call to VDP_DrawTile
		vdp_cmd	VRAM, WRITE, \addr
		lea	\src, a5
		move.w	#(\len)-1, d7
		bsr.w	VDP_DrawTile
	endm

drawtilemap:	macro	src, addr, width, height		; Simplifies setting up a call to VDP_DrawTilemap.
		lea	\src, a5
		vdp_cmd	VRAM, WRITE, \addr, d5
		move.w	#(\width)-1, d6
		move.w	#(\height)-1, d7
		bsr.w	VDP_DrawTilemap
	endm

; ====================================================================================================

	endif

; ====================================================================================================
; End of file
; ====================================================================================================