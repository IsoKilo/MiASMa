; ====================================================================================================
; FILE:		vdp.asm
; DESCRIPTION:	VDP related functions and variables.
; DATE:		24/08/2026
; AUTHOR:	Rachel "Kilo" Harrison
; ====================================================================================================

; Includes
	nolist
	include	"megadrive.inc"
	list
	include	"vdp.inc"

; ====================================================================================================

	section	.bss

vdp_regbuffer:	ds.b	VRBUFF_END				; VDP register buffer, to allow for reading VDP registers. SMS and 128KB VRAM registers have been excluded.
	dseven

; ====================================================================================================

	section	.text

VDP_Init:							; Initializes the VDP entirely.
		lea	VDP_CTRL, a6				; Load VDP control port.
		lea	vdp_regbuffer, a5			; Load VDP register buffer.
		lea	VDP_RegTbl, a4				; Load initial VDP register table.
		moveq	#(VRBUFF_END/word)-1, d7		; Set loop count.
.vreg_loop:
		move.w	(a4), (a5)+				; Write register data to register buffer.
		move.w	(a4)+, (a6)+				; Write register data to the VDP.
		dbf	d7, .vreg_loop				; Loop until all registers have beeen initialized.
		bsr.s	VDP_VRAMClear				; Clear VDP.
		bsr.s	VDP_CRAMClear
		bsr.s	VDP_VSRAMClear
		rts

VDP_RegTbl:
		dc.w	VREG_MODE1|VMD1_MODE4|VMD1_DISPON
		dc.w	VREG_MODE2|VMD2_DISPOFF|VMD2_DMA|VMD2_V28|VMD2_MD
		dc.w	VREG_PLNAADDR|VRAM_PLNA>>PLNA_BIT
		dc.w	VREG_WINADDR|VRAM_WIN>>WIN_BIT
		dc.w	VREG_PLNBADDR|VRAM_PLNB>>PLNB_BIT
		dc.w	VREG_SPRADDR|VRAM_SPR>>SPRTBL_BIT
		dc.w	VREG_BGCOLOR|0<<4|0
		dc.w	VREG_HINTRATE|DISP_V28-1
		dc.w	VREG_MODE3|VMD3_VSCRFULL|VMD3_HSCRFULL
		dc.w	VREG_MODE4|VMD4_H40
		dc.w	VREG_HSCRADDR|VRAM_HSCR>>HSCR_BIT
		dc.w	VREG_AUTOINC|word
		dc.w	VREG_PLNSIZE|PLNSIZE_64X32
		dc.w	VREG_WINXPOS|false<<7|0
		dc.w	VREG_WINYPOS|false<<7|0

; --------------------------------------------------

VDP_UpdateRegs:							; Updates VDP registers with those in the buffer.
		lea	VDP_CTRL, a6				; Load VDP control port.
		lea	vdp_regbuffer, a5			; Load VDP register buffer.
		moveq	#(VRBUFF_END/word)-1, d7		; Set loop count.
.vreg_loop:
		move.w (a5)+, (a6)				; Write register data to the VDP.
		dbf	d7, .vreg_loop				; Loop until all registers have been updated.
		rts

; --------------------------------------------------

VDP_VRAMClear:							; Clears VRAM.
		dma_fill	$00, $0000, VRAM_LENGTH
		rts

; --------------------------------------------------

VDP_CRAMClear:							; Clears CRAM.
		lea	VDP_DATA, a6				; Load VDP data port.
		vdp_cmd	CRAM, WRITE, $0000, 4(a6)		; Do a CRAM write to $0000.
		moveq	#0, d6
		moveq	#(CRAM_LENGTH/long)-1, d7		; Set loop count
.cram_clear:
		move.l	d6, (a6)				; Clear CRAM.
		dbf	d7, .cram_clear				; Loop until all of CRAM is cleared.
		rts

; --------------------------------------------------

VDP_VSRAMClear:							; Clears VSRAM.
		lea	VDP_DATA, a6				; Load VDP data port.
		vdp_cmd	VSRAM, WRITE, $0000, 4(a6)		; Do a VSRAM write to $0000.
		moveq	#0, d6
		moveq	#(VSRAM_LENGTH/long)-1, d7		; Set loop count
.vsram_clear:
		move.l	d6, (a6)				; Clear VSRAM.
		dbf	d7, .vsram_clear			; Loop until all of VSRAM is cleared.
		rts

; --------------------------------------------------

VDP_DrawTile:							; Draws d7-1 tiles from (a5) to the VDP.
		lea	VDP_DATA, a6				; Load VDP data port.
.tile_loop:
	rept 8
		move.l	(a5)+, (a6)				; Write tile data to the VDP.
	endr
		dbf	d7, .tile_loop
		rts

; --------------------------------------------------

VDP_DrawTilemap:						; Draws a (d6-1)X(d7-1) tilemap from (a5) to the VDP. d5 = Initial VDP command.
		lea	VDP_DATA, a6				; Load VDP data port.
		moveq	#0, d4
		move.b	vdp_regbuffer+VRBUFF_PLNSIZE+1, d4	; Fetch plane size.
		andi.b	#%11, d4				; Mask in only the width.
		asl.b	#2, d4					; Get long index.
		move.l	VDP_RowTbl(pc,d4.w), d4			; Get row addition.

.row_loop:
		move.l	d5, 4(a6)				; Write command to the VDP.
		move.w	d6, d3					; Copy width.
.tile_loop:
		move.w	(a5)+, (a6)				; Write tilemap data to the VDP.
		dbf	d3, .tile_loop				; Loop until all tiles in this row has been drawn.
		add.l	d4, d5					; Add row addition to VDP command.
		dbf	d7, .row_loop				; Loop until all rows have been drawn.
		rts

VDP_RowTbl:
		dc.l	(32*word)<<WORD_WIDTH
		dc.l	(64*word)<<WORD_WIDTH
		dc.l	0					; Unused
		dc.l	(128*word)<<WORD_WIDTH

; ====================================================================================================

	end

; ====================================================================================================
; End of file
; ====================================================================================================