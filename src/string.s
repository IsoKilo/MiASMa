; ====================================================================================================
; FILE:			string.s
; DESCRIPTION:	String rendering.
; DATE:			05/02/2026
; AUTHOR:		Rachel Harrison
; ====================================================================================================

	include	"src/megadrive.inc"
	include	"src/miasma.inc"
	include	"src/consts.inc"

; --------------------------------------------------

	section	ram

	xref	vdp_regbuff

; --------------------------------------------------

	section	code

	xref	vdp_loadtiles

	xdef	str_loadfont, str_toplane, str_tovram
	xdef	gfx_font

; Loads font set into VRAM.
str_loadfont:
		vdp_docmd	VRAM, WRITE, $0000
		lea		gfx_font, a0
		moveq	#95, d0
		bra.w	vdp_loadtiles

; Prints string to the plane.
; Input: a0 = String pointer, d0 = Initial VDP command.
; TODO: Replace VDP command input with X, Y, and layer input to make it easier to use user side.
str_toplane:
		lea		vdp_ctrl, a6
		move.l	d0, (a6)					; Do initial VDP write.
		moveq	#0, d1						; Character register.
		moveq	#0, d2
		move.w	vdp_regbuff+(12*WORD), d2	; Get plane map size.
		andi.w	#3, d2						; Mask in width only.
		asl.w	#2, d2						; Multiply by long
		move.l	row_tbl(pc,d2.w), d2		; Get row length to add for newline.
str_loop:
		move.b	(a0)+, d1					; Get next character.
		bmi.b	@code						; If it's negative it's a character code.
		subi.w	#" "+$0000, d1				; Subtract base character + tile index of font.
		move.w	d1, -4(a6)					; Write to VDP.
		bra.b	str_loop					; Loop until an end code is hit.
@code:
		moveq	#0, d3
		move.b	d1, d3						; Store character code.
		neg.b	d3							; Invert.
		subq.b	#1, d3
		asl.b	d3							; Multiply by word.
		move.w	code_tbl(pc,d3.w), d3
		jmp		code_tbl(pc,d3.w)			; Run corresponding code task.

row_tbl:
		dc.l	(((32*WORD)&$3FFF)<<16)|(((32*WORD)&$C000)>>14)		; 32 x Y.
		dc.l	(((64*WORD)&$3FFF)<<16)|(((64*WORD)&$C000)>>14)		; 64 x Y.
		dc.l	0													; Unused.
		dc.l	(((128*WORD)&$3FFF)<<16)|(((128*WORD)&$C000)>>14)	; 128 x Y.

code_tbl:
		dc.w	code_end-code_tbl
		dc.w	code_newline-code_tbl
		dc.w	code_normal-code_tbl
		dc.w	code_noflip-code_tbl
		dc.w	code_hflip-code_tbl
		dc.w	code_vflip-code_tbl
		dc.w	code_hvflip-code_tbl
		dc.w	code_pal0-code_tbl
		dc.w	code_pal1-code_tbl
		dc.w	code_pal2-code_tbl
		dc.w	code_pal3-code_tbl
		dc.w	code_lopri-code_tbl
		dc.w	code_hipri-code_tbl

code_end:
		rts								; Exit out string loop.
code_newline:
		add.l	d2, d0					; Add row length to VDP write command.
		move.l	d0, (a6)				; Write to VDP.
		bra.w	str_loop
code_normal:
		andi.w	#$07FF, d1				; Mask out any tile flags.
		bra.w	str_loop
code_noflip:
		andi.w	#$E7FF, d1				; Mask out flip flags.
		bra.w	str_loop
code_hflip:
		andi.w	#$E7FF, d1				; Mask out flip flags.
		ori.w	#$0800, d1				; Set horizontal flip.
		bra.w	str_loop
code_vflip:
		andi.w	#$E7FF, d1				; Mask out flip flags.
		ori.w	#$1000, d1				; Set vertical flip.
		bra.w	str_loop
code_hvflip:
		ori.w	#$1800, d1				; Set horizontal and vertical flip.
		bra.w	str_loop
code_pal0:
		andi.w	#$9FFF, d1				; Mask out palette bits.
		bra.w	str_loop
code_pal1:
		andi.w	#$9FFF, d1				; Mask out palette bits.
		ori.w	#$2000, d1				; Set palette line 1.
		bra.w	str_loop
code_pal2:
		andi.w	#$9FFF, d1				; Mask out palette bits.
		ori.w	#$4000, d1				; Set palette line 2.
		bra.w	str_loop
code_pal3:
		ori.w	#$6000, d1				; Set palette line 3.
		bra.w	str_loop
code_lopri:
		andi.w	#$7FFF, d1				; Mask out priority bit.
		bra.w	str_loop
code_hipri:
		ori.w	#$8000, d1				; Set priority but.
		bra.w	str_loop

; Writes character tiles from string to VRAM.
; Does not support character codes.
; Prerequisite: vdp_docmd	VRAM, WRITE, address
; Input: a0 = String pointer.
str_tovram:
		lea		vdp_data, a6
@loop:
		moveq	#0, d0
		move.b	(a0)+, d0				; Get next character.
		bmi.b	@end					; If it's negative just assume it's an end code. String codes don't apply.
		subi.b	#" ", d0				; Subtract base character.
		asl.w	#5, d0					; Multiply by 32 to get tile index.
		lea		gfx_font(pc,d0.w), a1	; Load font at tile index.
	rept 8
		move.l	(a1)+, (a6)				; Write tile data to VDP.
	endr
		bra.b	@loop					; Loop until an end code is hit
@end:
		rts

gfx_font:
	incbin	"src/font.gfx"

; ====================================================================================================
	end
; ====================================================================================================