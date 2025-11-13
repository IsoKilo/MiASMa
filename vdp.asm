; ====================================================================================================
; vdp.asm
; VPD functions

; Rachel Harrison
; 11/11/2025
; ====================================================================================================

	include	"md.lib"

; --------------------------------------------------

	section	.bss

	xdef	vdp_registercache
	xdef	vdp_palettebuffer

vdp_registercache:		ds.w 20						; VDP register cache. This is so we have a way of reading registers and syncing registers across the engine.
vdp_palettebuffer:		ds.b CRAM_LENGTH			; Palette buffer, gets DMA'd into CRAM every V-int.
	dseven

; --------------------------------------------------

	section	.text

	xdef	vdp_registerinit
	xdef	vdp_vramclear, vdp_cramclear, vdp_vsramclear
	xdef	vdp_tileload, vdp_tilemapload, vdp_palload

vdp_registerinit:
		lea		register_table, a0
		lea		vdp_control, a1
		lea		vdp_registercache, a2
		moveq	#20-1, d0							; Set loop counter.
		
@loop:
		move.w	(a0), (a1)							; Write from table to control port.
		move.w	(a0)+, (a2)+						; Copy into cache and increment to next register.
		dbf		d0, @loop
		rts

register_table:
		dc.w	vdpreg_mode1|%000100
		dc.w	vdpreg_mode2|%00110100
		dc.w	vdpreg_planeavram|($C000>>10)
		dc.w	vdpreg_windowvram|($F000>>10)
		dc.w	vdpreg_planebvram|($E000>>13)
		dc.w	vdpreg_spritevram|($D800>>9)
		dc.w	vdpreg_bgcolor|$00
		dc.w	vdpreg_hintrate|224-1
		dc.w	vdpreg_mode3|%0000
		dc.w	vdpreg_mode4|%10000001
		dc.w	vdpreg_hscrollvram|($DC00>>10)
		dc.w	vdpreg_autoinc|2
		dc.w	vdpreg_planesize|%000000
		dc.w	vdpreg_windowx|0
		dc.w	vdpreg_windowy|0
		dc.l	vdpreg_dmalength|((($0000>>1)&$FF00)<<8)|(($0000>>1)&$FF)
		dc.l	vdpreg_dmasource|((($000000>>1)&$FF00)<<8)|(($000000>>1)&$FF)
		dc.w	vdpreg_dmacommand|((($000000>>1)&$7F0000)>>16)

; Clears VRAM.

vdp_vramclear:
		move.w	#vdpreg_autoinc|1, vdp_control
		move.w	vdp_registercache+22, vdp_control	; Restore auto increment.
		rts

; Clears CRAM and palette variables.

vdp_cramclear:
		lea		vdp_palettebuffer, a0
		vdp_docommand	CRAM, WRITE, $0000
		moveq	#(CRAM_LENGTH/LONG)-1, d0			; Set loop count.
		moveq	#0, d1

@loop:
		move.l	d1, vdp_data						; Clear CRAM data.
		move.l	d1, (a0)+							; Clear palette buffer.
		dbf		d0, @loop
		rts

; Clears VSRAM and vertical scrolling variables.

vdp_vsramclear:
		vdp_docommand	VSRAM, WRITE, $0000
		moveq	#(VSRAM_LENGTH/LONG)-1, d0			; Set loop count.
		moveq	#0, d1

@loop:
		move.l	d1, vdp_data						; Clear VSRAM data.
		dbf		d0, @loop
		rts

; Loads uncompressed tile data into VRAM.

; Input
; d0.w - # of tiles-1
; a0.l - Tile data

vdp_tileload:
		lea		vdp_data, a1

@loop:
	rept 8
		move.l	(a0)+, (a1)							; Write tile data to VDP.
	endr
		dbf		d0, @loop
		rts

; Loads tilemap data to plane.

; Input
; d0.l - Initial VDP command.
; d1.w - Tilemap width-1
; d2.w - Tilemap height-1
; a0.l - Tilemap data

vdp_tilemapload:
		lea		vdp_data, a1
		move.w	vdp_registercache+24, d3			; Get plane size.
		and.w	#3, d3								; Mask in plane width.
		asl.b	#2,d3								; * LONG
		move.l	tilemap_rowlengths(pc,d3.w), d3		; Get corresponding row length.

@row:
		move.l	d0, vdp_control						; Go to next row.
		move.w	d1, d4								; Reset column loop count.

@column:
		move.w	(a0)+, (a1)							; Write tilemap data to VRAM.
		dbf		d4, @column							; Draw all columns in row.
		add.l	d3, d0								; Go to next row.
		dbf		d2, @row							; Draw all rows.
		rts

tilemap_rowlengths:
		dc.l	32*$20000
		dc.l	64*$20000
		dc.l	0*$20000	; unused
		dc.l	128*$20000

; Loads palette data into palette buffer.

; Input
; d0.w - First colour*2
; d1.w - # of colours-1
; a0.l - Palette data

vdp_palload:
		lea		vdp_palettebuffer, a1
		add.w	d0, a1								; Go to first colour.

@loop:
		move.w	(a0)+, (a1)+						; Write palette data to palette buffer.
		dbf		d1, @loop
		rts

; ====================================================================================================
	end
; ====================================================================================================