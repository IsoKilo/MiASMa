; ====================================================================================================
; string.asm
; String printing functions

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

string_fontload:
		vdp_docommand	VRAM, WRITE, $0000
		lea		font_cg, a0
		move.w	#95-1, d0
		bsr		vdp_tileload
		rts

; Input
; a0 - Address to string.
; d0 - Initial VDP command.

string_draw:
		move.l	d0, vdp_control	; Do initial VDP write.
		moveq	#0, d1

string_loop:
		move.b	(a0)+, d1		; Get next character.
		bmi.s	@code			; If it's negative, then this is a character code.
		sub.w	#" ", d1		; Subtract base character (space)
		move.w	d1, vdp_data	; Write tile data to VDP.
		bra.s	string_loop		; Loop until an end character is hit.

@code:
		rts

font_cg:
	incbin	"font.cg"

; ====================================================================================================
	end
; ====================================================================================================