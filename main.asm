; ====================================================================================================
; main.asm
; Program entry and main loop
; ====================================================================================================

	include	"md.lib"

; --------------------------------------------------

	section	.bss

	xdef	engine_scene, engine_initflag

engine_scene:			ds.l	1
engine_initflag:		ds.b	1
	dseven

; --------------------------------------------------

	section	.text

	xdef	main

	xref	int_init, vdp_registerinit
	xref	vdp_vramclear, vdp_cramclear, vdp_vsramclear
	xref	scene_example

main:
		tst.b	engine_initflag			; Has the console already been initialized?
		bne.s	@softreset				; If so, skip full initialization.				
		move.b	#1, engine_initflag		; Set flag for next time.
		move.b	io_systeminfo, d0		; Get system info.
		andi.b	#$F, d0					; Mask in only the version number.
		beq.s	@notmss					; If it's version 0, skip TMSS.
		move.l	#"SEGA", io_tmssstring	; Write SEGA to TMSS string to unlock the VDP.

@notmss:
		move.w	vdp_control, d0			; Flush out any leftover VDP commands.
		lea		ram_start, a0			; Load RAM.
		move.w	#(RAM_LENGTH/LONG)-1, d0	; Set loop count.
		moveq	#0, d1

@ramclear:
		move.l	d1, (a0)+				; Clear RAM and increment.
		dbf		d0, @ramclear

		bsr		int_init
		bsr		vdp_registerinit

@softreset:
		move.w	vdp_control, d0			; Flush out any leftover VDP commands.
		bsr		vdp_vramclear
		bsr		vdp_cramclear
		bsr		vdp_vsramclear
		move.l	#scene_example, engine_scene

main_loop:
		jsr		engine_scene			; Run scene for this loop.
		bra.s	main_loop				; Loop program forever.

; ====================================================================================================
	end
; ====================================================================================================