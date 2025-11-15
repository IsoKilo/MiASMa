; ====================================================================================================
; string.asm
; String printing functions.

; Rachel Harrison
; 11/11/2025
; ====================================================================================================

	include	"md.lib"

; --------------------------------------------------

	xref	vdp_registercache

	xdef	STRING_NEWLINE
	xdef	STRING_PALETTE0, STRING_PALETTE1, STRING_PALETTE2, STRING_PALETTE3
	xdef	STRING_LOPRIORITY, STRING_HIPRIORITY
	xdef	STRING_NOFLIP, STRING_HFLIP, STRING_VFLIP, STRING_HVFLIP
	xdef	STRING_END

STRING_NEWLINE:		equ -1
STRING_PALETTE0:	equ -2
STRING_PALETTE1:	equ -3
STRING_PALETTE2:	equ -4
STRING_PALETTE3:	equ -5
STRING_LOPRIORITY:	equ -6
STRING_HIPRIORITY:	equ -7
STRING_NOFLIP:		equ -8
STRING_HFLIP:		equ -9
STRING_VFLIP:		equ -10
STRING_HVFLIP:		equ -11
STRING_END:			equ -12

; --------------------------------------------------

	section	.text

	xdef	string_fontload, string_draw
	xdef	font_cg

	xref	vdp_tileload

; Loads standard font file into VRAM.

string_fontload:
		vdp_docommand	VRAM, WRITE, $0000
		lea		font_cg, a0
		move.w	#95-1, d0							; Set loop counter.
		bsr		vdp_tileload
		rts

; Draws a string to the plane.

; Input
; d0.l - VDP command
; a0.l - String data

string_draw:
		move.w	vdp_registercache+24, d3			; Get plane size.
		andi.w	#3, d3								; Mask in plane width.
		asl.b	#2,d3								; * LONG
		move.l	newline_rowlengths(pc,d3.w), d3		; Get corresponding row length.
		move.l	d0, vdp_control						; Do initial VRAM write command.
		moveq	#0, d1

string_loop:
		move.b	(a0)+, d1							; Get next character.
		bmi.s	@code								; If it's negative, then this is a character code.
		subi.b	#" ", d1							; Subtract base character (space)
		move.w	d1, vdp_data						; Write tile data to VDP.
		bra.s	string_loop							; Loop until an end character is hit.

@code:
		moveq	#0, d2
		move.b	d1, d2
		neg.b	d2									; Invert code.
		subq.b	#1, d2
		asl.b	d2									; * WORD
		move.w	code_table(pc,d2.w), d2
		jmp		code_table(pc,d2.w)

newline_rowlengths:
		dc.l	(((32*LONG)&$3FFF)<<16)|(((32*LONG)&$C000)>>14)
		dc.l	(((64*LONG)&$3FFF)<<16)|(((64*LONG)&$C000)>>14)
		dc.l	0									; Unused.
		dc.l	(((128*LONG)&$3FFF)<<16)|(((128*LONG)&$C000)>>14)

code_table:
		dc.w	code_newline-code_table
		dc.w	code_palette0-code_table
		dc.w	code_palette1-code_table
		dc.w	code_palette2-code_table
		dc.w	code_palette3-code_table
		dc.w	code_lopriority-code_table
		dc.w	code_hipriority-code_table
		dc.w	code_noflip-code_table
		dc.w	code_hflip-code_table
		dc.w	code_vflip-code_table
		dc.w	code_hvflip-code_table
		dc.w	code_end-code_table

code_newline:
		add.l	d3, d0								; Go to next row.
		move.l	d0, vdp_control
		bra.w	string_loop							; Draw next character.

code_palette0:
		andi.w	#$9FFF, d1							; Mask out any palette bits.
		bra.w	string_loop							; Draw next character.

code_palette1:
		andi.w	#$9FFF, d1							; Mask out any palette bits.
		ori.w	#$2000, d1							; Set palette to 1.
		bra.w	string_loop							; Draw next character.

code_palette2:
		andi.w	#$9FFF, d1							; Mask out any palette bits.
		ori.w	#$4000, d1							; Set palette to 2.
		bra.w	string_loop							; Draw next character.

code_palette3:
		andi.w	#$9FFF, d1							; Mask out any palette bits.
		ori.w	#$6000, d1							; Set palette to 3.
		bra.w	string_loop							; Draw next character.

code_lopriority:
		andi.w	#$7FFF, d1							; Mask out priority bit.
		bra.w	string_loop							; Draw next character.

code_hipriority:
		ori.w	#$8000, d1							; Set priority bit.
		bra.w	string_loop							; Draw next character.

code_noflip:
		andi.w	#$E7FF, d1							; Mask out flip bits.
		bra.w	string_loop							; Draw next character.

code_hflip:
		andi.w	#$E7FF, d1							; Mask out flip bits.
		ori.w	#$0800, d1							; Set horizontal flip bit.
		bra.w	string_loop							; Draw next character.

code_vflip:
		andi.w	#$E7FF, d1							; Mask out flip bits.
		ori.w	#$1000, d1							; Set vertical flip bit.
		bra.w	string_loop							; Draw next character.

code_hvflip:
		ori.w	#$1800, d1							; Set both flip flags.
		bra.w	string_loop							; Draw next character.

code_end:
		rts

font_cg:
	incbin	"font.cg"

; ====================================================================================================
	end
; ====================================================================================================