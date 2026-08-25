; ====================================================================================================
; FILE:		string.asm
; DESCRIPTION:	String rendering functions.
; DATE:		24/08/2026
; AUTHOR:	Rachel "Kilo" Harrison
; ====================================================================================================

; Includes
	nolist
	include	"megadrive.inc"
	list
	include	"vdp.inc"
	include	"string.inc"

; ====================================================================================================

	section	.text

String_LoadFont:						; Loads included font into VRAM.
		drawtile	Font_GFX, FONT_TILE*TILE_LENGTH, (FONT_END-FONT_START)+1
		rts

; --------------------------------------------------

String_DrawPlane:						; Draws input string (a5) to plane. d7 = Initial VDP command.
		lea	VDP_DATA, a6				; Load VDP data port.
		move.l	d7, 4(a6)				; Write initial VDP command
		moveq	#0, d6
		move.b	vdp_regbuffer+VRBUFF_PLNSIZE+1, d6	; Fetch plane size.
		andi.b	#%11, d6				; Mask in only the width.
		asl.b	#2, d6					; Get long index.
		move.l	String_RowTbl(pc,d6.w), d6		; Get row addition.
		moveq	#0, d5

String_PlaneLoop:
		andi.w	#~$7FF, d5				; Mask out tile ID.
		move.b	(a5)+, d5				; Write character data to register.
		bmi.b	.code					; If negative, it's a string code.
	if (FONT_START>0)&(FONT_TILE>0)
		addi.w	#FONT_TILE-FONT_START, d5		; Offset character ID by font start and tile ID.
	elseif FONT_START>0
		subi.w	#FONT_START, d5				; Offset character ID by font start.
	elseif FONT_TILE>0
		addi.w	#FONT_TILE, d5				; Offset character ID by font tile ID.
	endif
		move.w	d5, (a6)				; Write tile data to the VDP.
		bra.b	String_PlaneLoop			; Loop until an end code has been hit.

.code:
		move.w	d5, d4					; Copy character code.
		andi.w	#BYTE_MAX, d4				; Only get the low byte.
		neg.b	d4					; Invert code.
		subi.b	#word, d4				; Start at base 0.
		move.w	String_CodeTbl(pc,d4.w),d4		; Get table offset.
		jmp	String_CodeTbl(pc,d4.w)			; Execute string code.

String_CodeTbl:
		dc.w	StringCode_End-String_CodeTbl		; End string rendering.
		dc.w	StringCode_NewLine-String_CodeTbl	; Draw a new line.
		dc.w	StringCode_Reset-String_CodeTbl		; Reset rendering flags.
		dc.w	StringCode_NoFlip-String_CodeTbl	; Disable horizontal/vertical flipping.
		dc.w	StringCode_HFlip-String_CodeTbl		; Horizontally flip the font.
		dc.w	StringCode_VFlip-String_CodeTbl		; Vertically flip the font.
		dc.w	StringCode_HVFlip-String_CodeTbl	; Horizontally and vertically flip the font.
		dc.w	StringCode_Pal1-String_CodeTbl		; Set font palette line to 1.
		dc.w	StringCode_Pal2-String_CodeTbl		; Set font palette line to 2.
		dc.w	StringCode_Pal3-String_CodeTbl		; Set font palette line to 3.
		dc.w	StringCode_Pal4-String_CodeTbl		; Set font palette line to 4.
		dc.w	StringCode_LoPri-String_CodeTbl		; Set font to low priority.
		dc.w	StringCode_HiPri-String_CodeTbl		; Set font to high priority.
		dc.w	StringCode_Special-String_CodeTbl	; Draw a specified tile ID for special icons.

String_RowTbl:
		dc.l	(32*word)<<WORD_WIDTH
		dc.l	(64*word)<<WORD_WIDTH
		dc.l	0					; Unused
		dc.l	(128*word)<<WORD_WIDTH

StringCode_End:							; End string rendering.
		rts

StringCode_NewLine:						; Draw a new line.
		add.l	d6, d7					; Add row addition to VDP command.
		move.l	d7, 4(a6)				; Write command to the VDP.
		bra.w	String_PlaneLoop			; Loop until an end code has been hit.

StringCode_Reset:						; Reset rendering flags.
		andi.w	#$7FF, d5 				; Mask in only the tile ID.
		bra.w	String_PlaneLoop			; Loop until an end code has been hit.

StringCode_NoFlip:						; Disable horizontal/vertical flipping.
		andi.w	#~(VFLAG_HFLIP|VFLAG_VFLIP), d5		; Mask out horizontal and vertical flipping flags.
		bra.w	String_PlaneLoop			; Loop until an end code has been hit.

StringCode_HFlip:						; Horizontally flip the font.
		andi.w	#~VFLAG_VFLIP, d5			; Mask out vertical flipping flag.
		ori.w	#VFLAG_HFLIP, d5			; Set horizontal flipping flags.
		bra.w	String_PlaneLoop			; Loop until an end code has been hit.

StringCode_VFlip:						; Vertically flip the font.
		andi.w	#~VFLAG_HFLIP, d5			; Mask out horizontal flipping flag.
		ori.w	#VFLAG_VFLIP, d5			; Set vertical flipping flags.
		bra.w	String_PlaneLoop			; Loop until an end code has been hit.

StringCode_HVFlip:						; Horizontally and vertically flip the font.
		ori.w	#VFLAG_HFLIP|VFLAG_VFLIP, d5		; Set horizontal and vertical flipping flags.
		bra.w	String_PlaneLoop			; Loop until an end code has been hit.

StringCode_Pal1:						; Set font palette line to 1.
		andi.w	#~VFLAG_PAL4, d5			; Mask out palette line bits.
		bra.w	String_PlaneLoop			; Loop until an end code has been hit.

StringCode_Pal2:						; Set font palette line to 2.
		andi.w	#~VFLAG_PAL4, d5			; mask out palette line bits.
		ori.w	#VFLAG_PAL2, d5				; Set to palette line 2.
		bra.w	String_PlaneLoop			; Loop until an end code has been hit.

StringCode_Pal3:						; Set font palette line to 3.
		andi.w	#~VFLAG_PAL4, d5			; mask out palette line bits.
		ori.w	#VFLAG_PAL3, d5				; Set to palette line 3.
		bra.w	String_PlaneLoop			; Loop until an end code has been hit.

StringCode_Pal4:						; Set font palette line to 4.
		ori.w	#VFLAG_PAL4, d5				; Set to palette line 4.
		bra.w	String_PlaneLoop			; Loop until an end code has been hit.

StringCode_LoPri:						; Set font to low priority.
		andi.w	#~VFLAG_PRIO&WORD_MAX, d5		; Mask out high priority flag. AND with WORD_MAX because assembler can't truncate this from 32-bits.
		bra.w	String_PlaneLoop			; Loop until an end code has been hit.

StringCode_HiPri:						; Set font to high priority.
		ori.w	#VFLAG_PRIO, d5				; Set high priority flag.
		bra.w	String_PlaneLoop			; Loop until an end code has been hit.

StringCode_Special:						; Draw a specified tile ID for special icons.
		push.w	d5					; Store character register.
		moveq	#0, d5
		move.b	(a5)+, d5				; Get high byte of tile data. We do this in half to prevent address errors.
		lsl.w	#BYTE_WIDTH, d5				; Shift over into high byte.
		move.b	(a5)+, d5				; Get low byte of tile data.
		move.w	d5, (a6)				; Write special tile to the VDP.
		pop.w	d5					; Restore character register.
		bra.w	String_PlaneLoop			; Loop until an end code has been hit.

; --------------------------------------------------

String_DrawVRAM:						; Draws input string (a5) to VRAM.
		lea	VDP_DATA, a6				; Load VDP data port.
.loop:
		moveq	#0, d7
		move.b	(a5)+, d7				; Get next character.
		bmi.b	.exit					; If negative, end drawing tiles.
	if (FONT_START>0)&(FONT_TILE>0)
		addi.w	#FONT_TILE-FONT_START, d7		; Offset character ID by font start and tile ID.
	elseif FONT_START>0
		subi.w	#FONT_START, d7				; Offset character ID by font start.
	elseif FONT_TILE>0
		addi.w	#FONT_TILE, d7				; Offset character ID by font tile ID.
	endif
		asl.w	#5, d7					; Multiply by 32 to get tile length.
		lea	Font_GFX, a4				; Load font.
		adda.w	d7, a4					; Apply tile ID.
	rept 8
		move.l	(a4)+, (a6)				; Write tile data to VRAM.
	endr
		bra.b	.loop					; Loop until entire string has been drawn.

.exit:
		rts

; ====================================================================================================

	section	.data

Font_GFX:
	incbin	"font.gfx"
	even

; ====================================================================================================

	end

; ====================================================================================================
; End of file
; ====================================================================================================