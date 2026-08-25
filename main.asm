; ====================================================================================================
; FILE:		main.asm
; DESCRIPTION:	Main program entry and engine loop.
; DATE:		24/08/2026
; AUTHOR:	Rachel "Kilo" Harrison
; ====================================================================================================

; Includes
	nolist
	include	"megadrive.inc"
	list
	include	"vdp.inc"
	include	"string.inc"
	include	"main.inc"

; ====================================================================================================

	section	.bss

engine_scene:		ds.l	1				; Engine scene pointer.
	dseven

; ====================================================================================================

	section	.text

Main:								; Main program entry.
		irq_off						; Disable interrupts.

		; TMSS check.
		move.b	IO_SYSINFO, d0				; Fetch system info.
		andi.b	#$0F, d0				; Mask in only the version number.
		beq.b	.tmss_skip				; If 0, skip writing to TMSS register.
		move.l	#"SEGA", IO_TMSSSTR			; Write "SEGA" to the TMSS register to unlock the VDP.
.tmss_skip:
		move.w	VDP_CTRL, d0				; Get VDP status to flush any command leftovers.

		; System initialization.
		bsr.w	VDP_Init				; Initialize the VDP.

		; Variable initialization.
		move.l	#Scene_Example, engine_scene		; Initialize scene pointer.

Main_Loop:							; Engine loop.
		movea.l	engine_scene, a0			; Fetch the scene pointer.
		beq.w	Main					; Reset the game if null to prevent crashes.
		jsr	(a0)					; Execute scene.
		bra.b	Main_Loop				; Loop the engine forever.

Scene_Example:
		; Initialize the palette
		vdp_cmd	CRAM, WRITE, $0002, VDP_CTRL
		move.w	#COLOR_WHITE, VDP_DATA
		vdp_cmd	CRAM, WRITE, $0022, VDP_CTRL
		move.w	#COLOR_RED, VDP_DATA
		vdp_cmd	CRAM, WRITE, $0042, VDP_CTRL
		move.w	#COLOR_GREEN, VDP_DATA
		vdp_cmd	CRAM, WRITE, $0062, VDP_CTRL
		move.w	#COLOR_BLUE, VDP_DATA

		; Draw hello world strings.
		bsr.w	String_LoadFont
		stringplane	Example_String, VRAM_PLNA
;		stringvram	Example_String, $0020

		; Enable the display.
		ori.b	#VMD2_DISPON, vdp_regbuffer+VRBUFF_MODE2+1
		bsr.w	VDP_UpdateRegs
.loop:
		cmpi.l	#Scene_Example, engine_scene
		beq.b	.loop
		rts

Example_String:
		dc.b	"Hello, world!", STRCODE_NEWLINE
		dc.b	STRCODE_PAL2, "Hello, world!", STRCODE_NEWLINE
		dc.b	STRCODE_PAL3, "Hello, world!", STRCODE_NEWLINE
		dc.b	STRCODE_PAL4, "Hello, world!", STRCODE_END
		even

; ====================================================================================================

	end

; ====================================================================================================
; End of file
; ====================================================================================================