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
		moveq	#95-1, d0
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
		moveq	#0, d2
		move.b	d1, d2			; Copy character code.
		asl.b	d2				; Multiply by 2 to get offset.
		move.w	code_table(pc,d2.w), d2
		jmp		code_table(pc,d2.w)	; Run code.

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
		moveq	#0, d2
		move.b	vdp_registercache+25, d2	; Get current plane size.
		and.b	#%11, d2					; We only need the upper 2 bytes.
		asl.b	#2, d2						; Multiply into a long.
		move.l	newline_rows(pc,d2.w), d2	; Get corresponding row skip length.
		add.l	d2, d0						; Go to next row.
		move.l	d0, vdp_control
		bra.w	string_loop					; Run next character.

newline_rows:
		dc.l	32*$20000					; 32xY
		dc.l	64*$20000					; 64xY
		dc.l	0*$20000					; Unused
		dc.l	128*$20000					; 128xY

code_palette0:
		and.w	#$9FFF, d1					; Mask out any palette flags.
		bra.w	string_loop					; Run next character.

code_palette1:
		and.w	#$9FFF, d1					; Mask out palette flags.
		or.w	#$2000, d1					; Set to palette 1.
		bra.w	string_loop					; Run next character.

code_palette2:
		and.w	#$9FFF, d1					; Mask out palette flags.
		or.w	#$4000, d1					; Set to palette 2.
		bra.w	string_loop					; Run next character.

code_palette3:
		and.w	#$9FFF, d1					; Mask out palette flags.
		or.w	#$6000, d1					; Set to palette 3.
		bra.w	string_loop					; Run next character.

code_lopriority:
		and.w	#$7FFF, d1					; Mask out priority flag.
		bra.w	string_loop					; Run next character.

code_hipriority:
		or.w	#$8000, d1					; Set priority flag.
		bra.w	string_loop					; Run next character.

code_noflip:
		and.w	#$E7FF, d1					; Mask out any flip flags.
		bra.w	string_loop					; Run next character.

code_hflip:
		or.w	#$0800, d1					; Set H flip flag.
		bra.w	string_loop					; Run next character.

code_vflip:
		or.w	#$1000, d1					; Set V flip flag.
		bra.w	string_loop					; Run next character.

code_hvflip:
		or.w	#$1800, d1					; Set both H and V flip flags.
		bra.w	string_loop					; Run next character.

code_end:
		rts									; Exit out of drawing code.

font_cg:
	incbin	"font.cg"

; ====================================================================================================
	end
; ====================================================================================================