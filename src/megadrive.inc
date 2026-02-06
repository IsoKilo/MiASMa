; ====================================================================================================
; FILE:			megadrive.inc
; DESCRIPTION:	General/hardware definitions.
; DATE:			05/02/2026
; AUTHOR:		Rachel Harrison
; ====================================================================================================

; --------------------------------------------------
; General/Assembler
; --------------------------------------------------

; Master clock speeds (Hz)
CLOCK_MASTER_NTSC:	equ 53693175
CLOCK_MASTER_PAL:	equ 53203424

; Data widths
BYTE:				equ 1
WORD:				equ 2
LONG:				equ 4

; Minimum/maximum values
U8_MIN:				equ $00
U16_MIN:			equ $0000
U24_MIN:			equ $000000
U32_MIN:			equ $00000000

U8_MAX:				equ $FF
U16_MAX:			equ $FFFF
U24_MAX:			equ $FFFFFF
U32_MAX:			equ $FFFFFFFF

S8_MIN:				equ -$7F
S16_MIN:			equ -$7FFF
S24_MIN:			equ -$7FFFFF
S32_MIN:			equ -$7FFFFFFF

S8_MAX:				equ $7F
S16_MAX:			equ $7FFF
S24_MAX:			equ $7FFFFF
S32_MAX:			equ $7FFFFFFF

; Boolean
FALSE:				equ 0
TRUE:				equ $80

; Data alignment
align:				macros
	cnop	0, \1

ds_even:			macros
	ds.w	0

rs_even:			macros
	rs.b	__rs&1

; --------------------------------------------------

; --------------------------------------------------
; 68K
; --------------------------------------------------

; 68K clock speeds (Hz)
CLOCK_68K_NTSC:		equ 7670454
CLOCK_68K_PAL:		equ 7600489

; ROM address space
rom_start:			equ $000000
rom_128kb:			equ $020000
rom_256kb:			equ $040000
rom_512kb:			equ $080000
rom_1mb:			equ $100000
rom_2mb:			equ $200000
rom_4mb:			equ $400000

; RAM address space
ram_start:			equ $FF0000
ram_end:			equ $1000000
RAM_LEN:			equ ram_end-ram_start

; SRAM address space
sram_start:			equ $200001
sram_end:			equ $210000
SRAM_LEN:			equ sram_end-sram_start

pc_out:				equ $800000	; PC serial out.

; Push/pop registers on stack
push:				macro
	if narg=0
		movem.l	d0-a6, -(sp)
	else
		movem.l	\1, -(sp)
	endif
	endm

pop:				macro
	if narg=0
		movem.l	(sp)+, d0-a6
	else
		movem.l	(sp)+, \1
	endif
	endm

; Interrupt toggle
int_enable:			macros
		move.w	#$2300, sr

int_disable:		macros
		move.w	#$2700, sr

; Absolute conversion
abs:				macro
		tst.\0	\1
		bpl.b	@positive\@
		neg.\0	\1
@positive\@:
	endm

moveabs:			macro
		move.\0	\1, \2
		bpl.b	@positive\@
		neg.\0	\2
@positive\@:
	endm

; Conditional long branches
jhi:				macro
		bls.b	@cont\@
		jmp		\1
@cont\@:
	endm

jls:				macro
		bhi.b	@cont\@
		jmp		\1
@cont\@:
	endm

jcc:				macro
		bcs.b	@cont\@
		jmp		\1
@cont\@:
	endm

jcs:				macro
		bcc.b	@cont\@
		jmp		\1
@cont\@:
	endm

jne:				macro
		beq.b	@cont\@
		jmp		\1
@cont\@:
	endm

jeq:				macro
		bne.b	@cont\@
		jmp		\1
@cont\@:
	endm

jpl:				macro
		bmi.b	@cont\@
		jmp		\1
@cont\@:
	endm

jmi:				macro
		bpl.b	@cont\@
		jmp		\1
@cont\@:
	endm

jge:				macro
		blt.b	@cont\@
		jmp		\1
@cont\@:
	endm

jlt:				macro
		bge.b	@cont\@
		jmp		\1
@cont\@:
	endm

jgt:				macro
		ble.b	@cont\@
		jmp		\1
@cont\@:
	endm

jle:				macro
		bgt.b	@cont\@
		jmp		\1
@cont\@:
	endm

; --------------------------------------------------

; --------------------------------------------------
; Z80
; --------------------------------------------------

; Z80 clock speeds (Hz)
CLOCK_Z80_NTSC:		equ 3579545
CLOCK_Z80_PAL:		equ 3546894

; Z80 RAM address space
z80_start:			equ $A00000
z80_end:			equ $A02000
Z80_LEN:			equ z80_end-z80_start

; Z80 ports
z80_busreq:			equ $A11100	; Z80 bus request.
z80_reset:			equ $A11200	; Z80 reset line.
z80_bank:			equ $A06000	; Z80 68K bank page.
z80_68k:			equ $A08000	; Z80 68K bank.

; Z80 assert/release
z80_buson:			macros
		move.w	#$000, z80_busreq

z80_busoff:			macros
		move.w	#$100, z80_busreq

z80_buswait:		macro
@z80_wait\@:
		btst	#0, z80_busreq
		bne.b	@z80_wait\@
	endm

z80_reseton:		macros
		move.w	#$000, z80_reset

z80_resetoff:		macros
		move.w	#$100, z80_reset

; --------------------------------------------------

; --------------------------------------------------
; I/O
; --------------------------------------------------

; I/O ports
io_sysinfo:			equ $A10001
io_p1data:			equ $A10003
io_p2data:			equ $A10005
io_p3data:			equ $A10007
io_p1ctrl:			equ $A10009
io_p2ctrl:			equ $A1000B
io_p3ctrl:			equ $A1000D
io_s1tx:			equ $A1000F
io_s1rx:			equ $A10011
io_s1ctrl:			equ $A10013
io_s2tx:			equ $A10015
io_s2rx:			equ $A10017
io_s2ctrl:			equ $A10019
io_s3tx:			equ $A1001B
io_s3rx:			equ $A1001D
io_s3ctrl:			equ $A1001F
io_memmode:			equ $A11000
io_marsstr:			equ $A130EC
io_sramflg:			equ $A130F1
io_bank1:			equ $A130F3
io_bank2:			equ $A130F5
io_bank3:			equ $A130F7
io_bank4:			equ $A130F9
io_bank5:			equ $A130FB
io_bank6:			equ $A130FD
io_bank7:			equ $A130FF
io_tmssstr:			equ $A14000
io_tmssflg:			equ $A14101

; --------------------------------------------------

; --------------------------------------------------
; VDP
; --------------------------------------------------

; VDP clock speeds (Hz)
CLOCK_VDP_NTSC:		equ 13423294
CLOCK_VDP_PAL:		equ 13300856
CLOCK_PIXEL_NTSC:	equ 6711647
CLOCK_PIXEL_PAL:	equ 6650428

; VDP ports
vdp_data:			equ $C00000	; VDP data port.
vdp_ctrl:			equ $C00004	; VDP control port.
vdp_hvcount:		equ $C00008	; Horizontal/vertical scanline counter.
vdp_dbgreg:			equ $C00018	; Debug register selector.
vdp_dbgdat:			equ $C0001C	; Debug register data.

; VDP registers
vreg_mode1:			equ $8000		; VDP mode 1.
vreg_mode2:			equ $8100		; VDP mode 2.
vreg_plnaadr:		equ $8200		; Plane A nametable address >> 10.
vreg_winadr:		equ $8300		; Window nametable address >> 10.
vreg_plnbadr:		equ $8400		; Plane B nametable address >> 13.
vreg_spradr:		equ $8500		; Sprite table address >> 9.
vreg_spradr2:		equ $8600		; (128kb) Sprite table address >> 11.
vreg_bgcolor:		equ $8700		; Background color palette index.
vreg_mshscr:		equ $8800		; Master System horizontal scroll register.
vreg_msvscr:		equ $8900		; Master System vertical scroll register.
vreg_hintcnt:		equ $8A00		; Horizontal interrupt rate.
vreg_mode3:			equ $8B00		; VDP mode 3.
vreg_mode4:			equ $8C00		; VDP mode 4.
vreg_hscradr:		equ $8D00		; Horizontal scroll table address >> 10.
vreg_plnadr2:		equ $8E00		; Plane A and B nametable addresses (A >> 16), ((B & $10000) >> 12)
vreg_autoinc:		equ $8F00		; VDP read/write address auto increment.
vreg_plnsize:		equ $9000		; Plane map size.
vreg_winxpos:		equ $9100		; Window X division.
vreg_winypos:		equ $9200		; Window Y division.
vreg_dmalen:		equ $94009300	; DMA operation length.
vreg_dmarsrc:		equ $96009500	; DMA source address.
vreg_dmasrc2:		equ $9700		; Upper source address and DMA mode.

; VDP lengths
TILE_LEN:			equ 32
COLOR_LEN:			equ WORD
SPR_LEN:			equ 8
VRAM_LEN:			equ $10000
CRAM_LEN:			equ 64*COLOR_LEN
SPRTBL_LEN:			equ 80*SPR_LEN
HSCR_LEN:			equ 256*2*WORD
VSRAM_LEN:			equ 20*2*WORD

; Tile/sprite flags
VFLG_NOFLIP:		equ $0000
VFLG_HFLIP:			equ $0800
VFLG_VFLIP:			equ $1000
VFLG_HVFLIP:		equ $1800

VFLG_PAL0:			equ $0000
VFLG_PAL1:			equ $2000
VFLG_PAL2:			equ $4000
VFLG_PAL3:			equ $6000

VFLG_LOPRI:			equ $0000
VFLG_HIPRI:			equ $8000

; Sprite variables
spr_ypos:			equ 0
spr_size:			equ 2
spr_link:			equ 3
spr_tile:			equ 4
spr_xpos:			equ 6

; VDP commands
VCMD_VRAM:			equ %100001
VCMD_CRAM:			equ %101011
VCMD_VSRAM:			equ %100101

VCMD_READ:			equ %001100
VCMD_WRITE:			equ %000111
VCMD_DMA:			equ %100111

vdp_docmd:			macro	type, rwd, adr, ctrl
	local	cmd
cmd:				equ ((((VCMD_\type\&VCMD_\rwd\)&3)<<30)|((\adr\&$3FFF)<<16)|(((VCMD_\type\&VCMD_\rwd\)&$FC)<<2)|((\adr\&$C000)>>14))
	if narg<4
		move.l	#$\$cmd, vdp_ctrl
	else
		move.l	#$\$cmd, \ctrl
	endif
	endm

; DMA
DMAMD_XFER:			equ %00<<6	; Transfer from 68K to VDP.
DMAMD_FILL:			equ %10<<6	; Fill VRAM.
DMAMD_COPY:			equ %11<<6	; Copy from VRAM to VRAM.

vdp_dmawait:		macro
@dma_wait\@:
	if narg=0
		move.w	vdp_ctrl, d7
	else
		move.w	\1, d7
	endif
		btst	#1, d7
		bne.b	@dma_wait\@
	endm

vdp_dmatransfer:	macro	type, src, adr, len, ctrl
	local	cmd
cmd:				equ ((((VCMD_\type\&VCMD_DMA)&3)<<30)|((\adr\&$3FFF)<<16)|(((VCMD_\type\&VCMD_DMA)&$FC)<<2)|((\adr\&$C000)>>14))
	if narg<5
		move.l	#vreg_dmalen|(((\len\/2)&$FF00)<<8)|((\len\/2)&$FF), vdp_ctrl
		move.l	#vreg_dmasrc|(((\src\/2)&$FF00)<<8)|((\src\/2)&$FF), vdp_ctrl
		move.w	#vreg_dmasrc2|DMAMD_XFER|((\src\>>17)&$7F), vdp_ctrl
		move.w	#($\$cmd)>>16, vdp_ctrl
		move.w	#($\$cmd)&$FFFF, -(sp)
		move.w	(sp)+, vdp_ctrl
	else
		move.l	#vreg_dmalen|(((\len\/2)&$FF00)<<8)|((\len\/2)&$FF), \ctrl
		move.l	#vreg_dmasrc|(((\src\/2)&$FF00)<<8)|((\src\/2)&$FF), \ctrl
		move.w	#vreg_dmasrc2|((\src\>>17)&$7F), \ctrl
		move.w	#($\$cmd)>>16, \ctrl
		move.w	#($\$cmd)&$FFFF, -(sp)
		move.w	(sp)+, \ctrl
	endif
	endm

vdp_dmafill:		macro	byte, adr, len, ctrl
	if narg<4
		move.w	#vreg_autoinc|BYTE, vdp_ctrl
		move.l	#vreg_dmalen|(((\len\-1)&$FF00)<<8)|((\len\-1)&$FF), vdp_ctrl
		move.w	#vreg_dmasrc2|DMAMD_FILL, vdp_ctrl
		vdp_docmd	VRAM, DMA, \adr
		move.w	#\byte\<<8, vdp_data
		vdp_dmawait
		move.w	#vreg_autoinc|WORD, vdp_ctrl
	else
		move.w	#vreg_autoinc|BYTE, \ctrl
		move.l	#vreg_dmalen|(((\len\-1)&$FF00)<<8)|((\len\-1)&$FF), \ctrl
		move.w	#vreg_dmasrc2|DMAMD_FILL, \ctrl
		vdp_docmd	VRAM, DMA, \adr, \ctrl
		move.w	#\byte\<<8, -4\ctrl
		vdp_dmawait	\ctrl
		move.w	#vreg_autoinc|WORD, \ctrl
	endif
	endm

vdp_dmacopy:		macro	src, adr, len, ctrl
	if narg<4
		move.w	#vreg_autoinc|BYTE, vdp_ctrl
		move.l	#vreg_dmalen|(((\len\-1)&$FF00)<<8)|((\len\-1)&$FF), vdp_ctrl
		move.l	#vreg_dmasrc|((\src\&$FF00)<<8)|(\src\&$FF), vdp_ctrl
		move.w	#vreg_dmasrc2|DMAMD_COPY, vdp_ctrl
		move.l	#$000000C0|((\adr\&$3FFF)<<16)|((\adr\&$C000)>>14), vdp_ctrl
		vdp_dmawait
		move.w	#vreg_autoinc|WORD, vdp_ctrl
	else
		move.w	#vreg_autoinc|BYTE, \ctrl
		move.l	#vreg_dmalen|(((\len\-1)&$FF00)<<8)|((\len\-1)&$FF), \ctrl
		move.l	#vreg_dmasrc|((\src\&$FF00)<<8)|(\src\&$FF), \ctrl
		move.w	#vreg_dmasrc2|DMAMD_COPY, \ctrl
		move.l	#$000000C0|((\adr\&$3FFF)<<16)|((\adr\&$C000)>>14), \ctrl
		vdp_dmawait	\ctrl
		move.w	#vreg_autoinc|WORD, \ctrl
	endif
	endm

; --------------------------------------------------

; --------------------------------------------------
; Sound
; --------------------------------------------------

; Sound ports
ym_a0:				equ $A04000	; YM-2612 address register.
ym_d0:				equ $A04001	; YM-2612 data register.
ym_a1:				equ $A04002
ym_d1:				equ $A04003

pc_yma0:			equ $840101	; PC serial ports.
pc_ymd0:			equ $840103
pc_yma1:			equ $840105
pc_ymd1:			equ $840103

psg_ctrl:			equ $C00011	; 68k side PSG control port.
psg_z80:			equ $A07F11	; Z80 side PSG control port.

; --------------------------------------------------

; ====================================================================================================
; End
; ====================================================================================================