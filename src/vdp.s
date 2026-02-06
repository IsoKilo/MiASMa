; ====================================================================================================
; FILE:			vdp.s
; DESCRIPTION:	VDP functions.
; DATE:			05/02/2026
; AUTHOR:		Rachel Harrison
; ====================================================================================================

	include	"src/megadrive.inc"
	include	"src/miasma.inc"
	include	"src/consts.inc"

; --------------------------------------------------

	section	ram

	xdef		vdp_regbuff

vdp_regbuff:	ds.w 15

; --------------------------------------------------

	section	code

	xdef	vdp_init, vdp_clearvram, vdp_clearcram, vdp_clearvsram
	xdef	vdp_loadtiles

vdp_init:
		bsr.b	vdp_initreg
		bsr.w	vdp_clearvram
		bsr.w	vdp_clearcram
		bsr.w	vdp_clearvsram
		rts		

vdp_initreg:
		lea		vdp_ctrl, a6
		lea		vdp_regbuff, a5
		lea		reg_inittbl, a4
		moveq	#((reg_inittblend-reg_inittbl)/WORD)-1, d7
@loop:
		move.w	(a4), (a5)+
		move.w	(a4)+, (a6)
		dbf		d7, @loop
		rts

reg_inittbl:
		dc.w	vreg_mode1|%00000100
		dc.w	vreg_mode2|%00110100
		dc.w	vreg_plnaadr|(PLNA_ADR>>10)
		dc.w	vreg_winadr|(WIN_ADR>>10)
		dc.w	vreg_plnbadr|(PLNB_ADR>>13)
		dc.w	vreg_spradr|(SPRTBL_ADR>>9)
		dc.w	vreg_bgcolor|(0<<4)|0
		dc.w	vreg_hintcnt|$FF
		dc.w	vreg_mode3|%00000111
		dc.w	vreg_mode4|%10000001
		dc.w	vreg_hscradr|(HSCR_ADR>>10)
		dc.w	vreg_autoinc|WORD
		dc.w	vreg_plnsize|%00000001
		dc.w	vreg_winxpos|FALSE|0
		dc.w	vreg_winypos|FALSE|0
reg_inittblend:

vdp_clearvram:
		vdp_dmafill	$00, $0000, VRAM_LEN
		rts

vdp_clearcram:
		vdp_docmd	CRAM, WRITE, $0000
		moveq	#(CRAM_LEN/LONG)-1, d6
		moveq	#0, d7
@loop:
		move.l	d7, vdp_data
		dbf		d6, @loop

vdp_clearvsram:
		vdp_docmd	VSRAM, WRITE, $0000
		moveq	#(VSRAM_LEN/LONG)-1, d6
		moveq	#0, d7
@loop:
		move.l	d7, vdp_data
		dbf		d6, @loop

vdp_loadtiles:
		lea		vdp_data, a6
		subq.b	#1, d0

@loop:
	rept 8
		move.l	(a0)+, (a6)
	endr
		dbf		d0, @loop
		rts

; ====================================================================================================
	end
; ====================================================================================================