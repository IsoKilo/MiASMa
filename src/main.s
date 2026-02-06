; ====================================================================================================
; FILE:			main.s
; DESCRIPTION:	Entry point and main program loop.
; DATE:			05/02/2026
; AUTHOR:		Rachel Harrison
; ====================================================================================================

	include	"src/megadrive.inc"
	include	"src/miasma.inc"
	include	"src/consts.inc"

; --------------------------------------------------

	section	ram

	xref	sys_stack

	xdef	eng_scene

eng_scene:	ds.l 1	; Engine scene pointer.

; --------------------------------------------------

	section	code

	xref	vdp_init

	xdef	main

main:
		moveq	#0, d0
		move.b	io_sysinfo, d0
		andi.b	#$F, d0				; Mask in system version only.
		beq.b	@tmss_skip			; If version 0, skip.
		move.l	#"SEGA", io_tmssstr	; Set TMSS signature to unlock the VDP.
@tmss_skip:
		int_disable					; Disable interrupts.
		z80_busoff					; Fetch bus.
		move.w	vdp_ctrl, d0		; Flush any VDP commands.
		lea		ram_start, a0		; Load RAM.
		moveq	#0, d0
		move.w	#(RAM_LEN/LONG)-1, d1
@ram_clear:
		move.l	d0, (a0)+			; Clear RAM and increment.
		dbf		d1, @ram_clear		; Loop until all of RAM is cleared.
		bsr.w	vdp_init
		move.l	#scene_temp, eng_scene
main_loop:
		movea.l	eng_scene, a0
		jsr		(a0)				; Run engine scene.
		bra.b	main_loop

	xref	str_loadfont, str_toplane

scene_temp:
		vdp_docmd	CRAM, WRITE, $0002
		move.w	#$EEE, vdp_data					; White
		vdp_docmd	CRAM, WRITE, $0022
		move.w	#$00E, vdp_data					; Red
		vdp_docmd	CRAM, WRITE, $0042
		move.w	#$0E0, vdp_data					; Green
		vdp_docmd	CRAM, WRITE, $0062
		move.w	#$E00, vdp_data					; Blue
		bsr.w	str_loadfont
		lea		helloworld, a0
		vdp_docmd	VRAM, WRITE, PLNA_ADR, d0	; Write to plane A.
		bsr.w	str_toplane
		move.w	#vreg_mode2|%01000100, vdp_ctrl	; Enable display

scene_loop:
		bra.b	scene_loop

helloworld:
		dc.b	STRCODE_NORMAL, "Hello, world!", STRCODE_NEWLINE
		dc.b	STRCODE_PAL1, "Hello, world!", STRCODE_NEWLINE
		dc.b	STRCODE_PAL2, "Hello, world!", STRCODE_NEWLINE
		dc.b	STRCODE_PAL3, "Hello, world!", STRCODE_NORMAL, STRCODE_NEWLINE
		dc.b	STRCODE_HFLIP, "Hello, world!", STRCODE_NEWLINE
		dc.b	STRCODE_VFLIP, "Hello, world!", STRCODE_NEWLINE
		dc.b	STRCODE_HVFLIP, "Hello, world!", STRCODE_NORMAL, STRCODE_NEWLINE
		dc.b	STRCODE_HIPRI, "Hello, world!", STRCODE_END

; ====================================================================================================
	end
; ====================================================================================================