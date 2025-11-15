; ====================================================================================================
; pal.asm
; VDP hardware functions.

; Rachel Harrison
; 14/11/2025
; ====================================================================================================

	include	"md.lib"

; --------------------------------------------------

	section	.bss

	xdef	pal_buffer1, pal_buffer2
	xdef	pal_frame1, pal_time1
	xdef	pal_frame2, pal_time2
	xdef	pal_frame3, pal_time3
	xdef	pal_frame4, pal_time4

pal_buffer1:			ds.b CRAM_LENGTH	; Palette buffer 1, target palette.
pal_buffer2:			ds.b CRAM_LENGTH	; Palette buffer 2, current palette.
pal_frame1:				ds.w 1				; Palette animation frame.
pal_time1:				ds.w 1				; Palette animation timer.
pal_frame2:				ds.w 1
pal_time2:				ds.w 1
pal_frame3:				ds.w 1
pal_time3:				ds.w 1
pal_frame4:				ds.w 1
pal_time4:				ds.w 1
	dseven

; --------------------------------------------------

	section	.text

	xdef	pal_load

; Loads palette data into palette buffer.

; Input
; d0.w - First colour*2
; d1.w - # of colours-1
; a0.l - Palette data

pal_load:
		lea		pal_buffer1, a1
		add.w	d0, a1							; Go to first colour.

@loop:
		move.w	(a0)+, (a1)+					; Write palette data to palette buffer.
		dbf		d1, @loop
		rts

; ====================================================================================================
	end
; ====================================================================================================