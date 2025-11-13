; ====================================================================================================
; example.asm
; Example scene

; Rachel Harrison
; 12/11/2025
; ====================================================================================================

	include	"md.lib"

; --------------------------------------------------

	xref	engine_scene
	xref	vdp_registercache

	xref	STRING_NEWLINE
	xref	STRING_PALETTE0, STRING_PALETTE1, STRING_PALETTE2, STRING_PALETTE3
	xref	STRING_LOPRIORITY, STRING_HIPRIORITY
	xref	STRING_NOFLIP, STRING_HFLIP, STRING_VFLIP, STRING_HVFLIP
	xref	STRING_END

; --------------------------------------------------

	section	.text

	xdef	scene_example

	xref	string_fontload, string_draw

scene_example:
		or.w	#$700, sr
		z80_buson
		bsr	string_fontload
		lea	example_string, a0
		vdp_docommand	VRAM, WRITE, $C000, d0
		bsr	string_draw
		move.w	#vdpreg_autoinc|1, vdp_control
		vdp_docommand	CRAM, WRITE, $0002
		move.w	#$EEE, vdp_data
		vdp_docommand	CRAM, WRITE, $0022
		move.w	#$00E, vdp_data
		vdp_docommand	CRAM, WRITE, $0042
		move.w	#$E00, vdp_data
		vdp_docommand	CRAM, WRITE, $0062
		move.w	#$0EE, vdp_data
		move.w	#vdpreg_autoinc|2, vdp_control
		move.w	#vdpreg_planesize|%000001, d0
		move.w	d0, vdp_registercache+24
		move.w	d0, vdp_control
		move.w	#vdpreg_mode2|%01110100, d0
		move.w	d0, vdp_registercache+2
		move.w	d0, vdp_control

example_loop:
		cmp.l	#scene_example, engine_scene
		beq.s	example_loop
		rts

example_string:
		dc.b	"Hello, world!", STRING_NEWLINE
		dc.b	STRING_PALETTE1, "Hello, world, but in red!", STRING_NEWLINE
		dc.b	STRING_PALETTE2, "Hello, world, but in blue!", STRING_NEWLINE
		dc.b	STRING_PALETTE3, "Hello, world, but in yellow!", STRING_END
		even

; ====================================================================================================
	end
; ====================================================================================================