; ====================================================================================================
; example.asm
; Example scene.

; Rachel Harrison
; 12/11/2025
; ====================================================================================================

	include	"md.lib"

; --------------------------------------------------

	xref	engine_scene
	xref	vdp_registercache
	xref	pal_buffer1

	xref	STRING_NEWLINE
	xref	STRING_PALETTE0, STRING_PALETTE1, STRING_PALETTE2, STRING_PALETTE3
	xref	STRING_LOPRIORITY, STRING_HIPRIORITY
	xref	STRING_NOFLIP, STRING_HFLIP, STRING_VFLIP, STRING_HVFLIP
	xref	STRING_END

; --------------------------------------------------

	section	.text

	xdef	scene_example

	xref	string_fontload, string_draw
	xref	vint_sync, vint_addr, int_start, int_end

scene_example:
		ori.w	#$700, sr							
		bsr	string_fontload						; Load up the standard ASCII font.
		lea	example_string, a0					; Get the example text.
		vdp_docommand	VRAM, WRITE, $C000, d0	; Draw the text on plane A.
		bsr	string_draw							; Draw the string.
		move.w	#$EEE, pal_buffer1+(1*WORD)		; White.
		move.w	#$00E, pal_buffer1+(16*WORD)	; Red.
		move.w	#$E00, pal_buffer1+(32*WORD)	; Blue.
		move.w	#$0EE, pal_buffer1+(48*WORD)	; Yellow.
		move.w	#%01110100, d0					; Enable the display, V-ints, and DMAs.
		move.w	d0, vdp_registercache+2
		move.w	d0, vdp_control
		move.l	#example_int, vint_addr

example_loop:
		bsr		vint_sync
		cmpi.l	#scene_example, engine_scene
		beq.s	example_loop
		rts

example_string:
		dc.b	"Hello, world!", STRING_NEWLINE
		dc.b	STRING_PALETTE1, "Hello, world, but in red!", STRING_NEWLINE
		dc.b	STRING_PALETTE2, "Hello, world, but in blue!", STRING_NEWLINE
		dc.b	STRING_PALETTE3, "Hello, world, but in yellow!", STRING_END
		even

example_int:
		bsr	int_start
		lea	vdp_control, a6
		dma_dotransfer	CRAM, pal_buffer1, $0000, 64, (a6)
		jmp	int_end

; ====================================================================================================
	end
; ====================================================================================================