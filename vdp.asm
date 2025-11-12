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

vdp_registercache:		ds.w 20
	dseven

; --------------------------------------------------

	section	.text

	xdef	vdp_registerinit
	xdef	vdp_vramclear, vdp_cramclear, vdp_vsramclear
	xdef	vdp_tileload

vdp_registerinit:
		lea		register_table, a0	; Load initial register table.
		lea		vdp_control, a1			; Get control port.
		lea		vdp_registercache, a2	; And cache.
		moveq	#20-1, d0				; Set loop counter.
		
@loop:
		move.w	(a0), (a1)				; Write from table to control port.
		move.w	(a0)+, (a2)+			; Copy into cache and increment to next register.
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

vdp_vramclear:
		move.w	#vdpreg_autoinc|1, vdp_control	; Set auto increment to 1 for DMA.
		move.w	vdp_registercache+22, vdp_control	; Restore auto increment.
		rts

vdp_cramclear:
		vdp_docommand	CRAM, WRITE, $0000
		moveq	#(CRAM_LENGTH/LONG)-1, d0
		moveq	#0, d1

@loop:
		move.l	d1, vdp_data
		dbf		d0, @loop
		rts

vdp_vsramclear:
		vdp_docommand	VSRAM, WRITE, $0000
		moveq	#(VSRAM_LENGTH/LONG)-1, d0
		moveq	#0, d1

@loop:
		move.l	d1, vdp_data
		dbf		d0, @loop
		rts

; Input
; a0 - Address to uncompressed tiles
; d0 - Tile count-1
vdp_tileload:
		lea		vdp_data, a1

@loop:
	rept 8
		move.l	(a0)+, (a1)
	endr
		dbf		d0, @loop
		rts

; ====================================================================================================
	end
; ====================================================================================================