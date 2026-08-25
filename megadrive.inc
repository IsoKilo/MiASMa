; ====================================================================================================
; FILE:		megadrive.inc
; DESCRIPTION:	Mega Drive hardware definitions.
; DATE:		24/08/2026
; AUTHOR:	Rachel "Kilo" Harrison
; ====================================================================================================

; Define once
	if ~def(__MEGADRIVE__)
__MEGADRIVE__ = 0

; ====================================================================================================

; --------------------------------------------------
; Assembler
; --------------------------------------------------

; Boolean
false:		equ 0
true:		equ 1

; Data types
byte:		equ 1						; 8-bit byte.
ubyte:		equ byte
sbyte:		equ byte

BYTE_WIDTH:	equ 8
UBYTE_WIDTH:	equ BYTE_WIDTH
SBYTE_WIDTH:	equ BYTE_WIDTH

BYTE_MIN:	equ $00
UBYTE_MIN:	equ $00
SBYTE_MIN:	equ -$7F

BYTE_MAX:	equ $FF
UBYTE_MAX:	equ $FF
SBYTE_MAX:	equ $7F

char:		equ 1						; 8-bit character.
uchar:		equ char
schar:		equ char

CHAR_WIDTH:	equ 8
UCHAR_WIDTH:	equ CHAR_WIDTH
SCHAR_WIDTH:	equ CHAR_WIDTH

CHAR_MIN:	equ $00
UCHAR_MIN:	equ $00
SCHAR_MIN:	equ -$7F

CHAR_MAX:	equ $FF
UCHAR_MAX:	equ $FF
SCHAR_MAX:	equ $7F

word:		equ 2						; 16-bit word.
uword:		equ word
sword:		equ word

WORD_WIDTH:	equ 16
UWORD_WIDTH:	equ WORD_WIDTH
SWORD_WIDTH:	equ WORD_WIDTH

WORD_MIN:	equ $0000
UWORD_MIN:	equ $0000
SWORD_MIN:	equ -$7FFF

WORD_MAX:	equ $FFFF
UWORD_MAX:	equ $FFFF
SWORD_MAX:	equ $7FFF

short:		equ 2						; 16-bit short word.
ushort:		equ short
sshort:		equ short

SHORT_WIDTH:	equ 16
USHORT_WIDTH:	equ SHORT_WIDTH
SSHORT_WIDTH:	equ SHORT_WIDTH

SHORT_MIN:	equ $0000
USHORT_MIN:	equ $0000
SSHORT_MIN:	equ -$7FFF

SHORT_MAX:	equ $FFFF
USHORT_MAX:	equ $FFFF
SSHORT_MAX:	equ $7FFF

long:		equ 4						; 32-bit long word.
ulong:		equ long
slong:		equ long

LONG_WIDTH:	equ 32
ULONG_WIDTH:	equ LONG_WIDTH
SLONG_WIDTH:	equ LONG_WIDTH

LONG_MIN:	equ $00000000
ULONG_MIN:	equ $00000000
SLONG_MIN:	equ -$7FFFFFFF

LONG_MAX:	equ $FFFFFFFF
ULONG_MAX:	equ $FFFFFFFF
SLONG_MAX:	equ $7FFFFFFF

int:		equ 4						; 32-bit integer.
uint:		equ int
sint:		equ int

INT_WIDTH:	equ 32
UINT_WIDTH:	equ INT_WIDTH
SINT_WIDTH:	equ INT_WIDTH

INT_MIN:	equ $00000000
UINT_MIN:	equ $00000000
SINT_MIN:	equ -$7FFFFFFF

INT_MAX:	equ $FFFFFFFF
UINT_MAX:	equ $FFFFFFFF
SINT_MAX:	equ $7FFFFFFF

; Alignment macros
align:		macros	alignment				; Aligns section to specified boundary.
	cnop	0, \alignment

rseven:		macros						; Aligns RS counter with next even value.
	rs.b	__rs&1

dseven:		macros						; Aligns storage to next even address.
	ds.w	0

; --------------------------------------------------

; --------------------------------------------------
; 68K
; --------------------------------------------------

; Clock speeds (Hz)
CLK_NTSC:	equ 53693175					; Master clock speed.
CLK_PAL:	equ 53203424

CLK_68K_NTSC:	equ CLK_NTSC/7					; 68k clock speed.
CLK_68K_PAL:	equ CLK_PAL/7

; ROM
ROM_START:	equ $000000
ROM_LENGTH:	equ $008000					; Max 4MB before a ROM mapper is required.
ROM_END:	equ ROM_START+ROM_LENGTH

; RAM
RAM_START:	equ $FF0000
RAM_LENGTH:	equ $10000
RAM_END:	equ RAM_START+RAM_LENGTH

; SRAM
SRAM_TYPE:	equ SRAM_SAVE
SRAM_ALIGN:	equ SRAM_ODD

SRAM_A_BIT:	equ 3						; SRAM alignment bit.
SRAM_S_BIT:	equ 6						; SRAM save flag.

SRAM_WORD:	equ %00<<SRAM_A_BIT				; SRAM is present on even and odd bytes.
SRAM_EVEN:	equ %10<<SRAM_A_BIT				; SRAM is present on even bytes only.
SRAM_ODD:	equ %11<<SRAM_A_BIT				; SRAM is present on odd bytes only.

SRAM_EXT:	equ false<<SRAM_S_BIT				; Use SRAM as external RAM.
SRAM_SAVE:	equ true<<SRAM_S_BIT				; Use SRAM as save data.

SRAM_START:	equ $200000+((SRAM_ALIGN>>SRAM_A_BIT)&1)	; Note: This can overlap with ROMs > 2MB, use IO_SRAMFLAG to toggle between ROM/SRAM access.
SRAM_LENGTH:	equ $10000-((SRAM_ALIGN>>SRAM_A_BIT)&1)
SRAM_END:	equ SRAM_START+SRAM_LENGTH

; Condition code register
CCR_C_BIT:	equ 0						; Carry flag.
CCR_V_BIT:	equ 1						; Overflow flag.
CCR_Z_BIT:	equ 2						; Zero flag.
CCR_N_BIT:	equ 3						; Negative flag.
CCR_X_BIT:	equ 4						; Extend flag.

CCR_CARRY:	equ true<<CCR_C_BIT
CCR_OVERFLOW:	equ true<<CCR_V_BIT
CCR_ZERO:	equ true<<CCR_Z_BIT
CCR_NEGATIVE:	equ true<<CCR_N_BIT
CCR_EXTEND:	equ true<<CCR_X_BIT

; Status register
SR_IM_BIT:	equ 8						; Interrupt request mask bit.
SR_S_BIT:	equ 13						; Supervisor mode flag. Always set on the Mega Drive.
SR_T_BIT:	equ 15						; Trace mode flag. Triggers trace exception after every instruction.

SR_IRQLVL1:	equ 0<<SR_IM_BIT
SR_IRQLVL2:	equ 1<<SR_IM_BIT
SR_IRQLVL3:	equ 2<<SR_IM_BIT
SR_IRQLVL4:	equ 3<<SR_IM_BIT
SR_IRQLVL5:	equ 4<<SR_IM_BIT
SR_IRQLVL6:	equ 5<<SR_IM_BIT
SR_IRQLVL7:	equ 6<<SR_IM_BIT
SR_IRQOFF:	equ 7<<SR_IM_BIT

SR_EXTINT:	equ SR_IRQLVL2					; External interrupt.
SR_HINT:	equ SR_IRQLVL4					; VDP horizontal interrupt.
SR_VINT:	equ SR_IRQLVL6					; VDP vertical interrupt.

SR_USER:	equ false<<SR_S_BIT
SR_SUPER:	equ true<<SR_S_BIT

SR_TRACE:	equ true<<SR_T_BIT

; Interrupt macros
irq_setlvl:	macro	level					; Sets interrupt mask to specified level.
	if instr("\level", "SR_")
		move.w	#SR_SUPER|\level, sr
	else
		move.w	#SR_SUPER|(\level\<<SR_IM_BIT), sr
	endif
	endm

irq_on:		macros						; Enables all interrupts.
		andi.w	#~SR_IRQOFF, sr

irq_off:	macros						; Disables all interrupts.
		ori.w	#SR_IRQOFF, sr

irq_extint:	macros						; Sets interrupt mask to external interrupt.
		move.w	#SR_SUPER|SR_EXTINT, sr

irq_hint:	macros						; Sets interrupt mask to VDP horizontal interrupt.
		move.w	#SR_SUPER|SR_HINT, sr

irq_vint:	macros						; Sets interrupt mask to VDP vertical interrupt.
		move.w	#SR_SUPER|SR_VINT, sr

; Push/pop registers to stack macros
push:		macro	regs					; Pushes registers to the stack.
	if narg>0
	if instr("\regs", "-")|instr("\regs", "/")
		movem.\0	\regs, -(sp)
	else
		move.\0	\regs, -(sp)
	endif
	else
		movem.l	d0-a6, -(sp)
	endif
	endm

pop:		macro	regs					; Pops registers from the stack.
	if narg>0
	if instr("\regs", "-")|instr("\regs", "/")
		movem.\0	(sp)+, \regs
	else
		move.\0	(sp)+, \regs
	endif
	else
		movem.l	(sp)+, d0-a6
	endif
	endm

; RAM clear macro
ram_clr:	macro	src, len
		lea	\src, a6
		moveq	#0, d7
	if (\len\&3)=0
		move.w	#(\len\/long)-1, d6
.ram_clear\@:
		move.l	d7, (a6)+
	elseif (\len\&1)=0
		move.w	#(\len\/word)-1, d6
.ram_clear\@:
		move.w	d7, (a6)+
	else
		move.w	#\len\-1, d6
.ram_clear\@:
		move.b	d7, (a6)+
	endif
		dbf	d6, .ram_clear\@
	endm

; Absolute value conversion macros
abs:		macro	src					; Converts source register to an absolute value.
		tst.\0	\src
		bpl.b	.positive\@
		neg.\0	\src
.positive\@:
	endm

movabs:		macro	src, dest				; Moves source register to destination and converts it to an absolute value.
		move.\0	\src, \dest
		bpl.b	.positive\@
		neg.\0	\dest
.positive\@:
	endm

; Bitfield flag macros (Useful for RPGs)
flagtst:	macros	flag, array				; Checks a flag bit from a flag array.
		btst	#\flag\&7, \array\+(\flag\>>3)

flag_set:	macros	flag, array				; Sets a flag bit in a flag array.
		bset	#\flag\&7, \array\+(\flag\>>3)

flag_clr:	macros	flag, array				; Clears a flag bit in a flag array.
		bclr	#\flag\&7, \array\+(\flag\>>3)

flag_chg:	macros	flag, array				; Flips a flag bit in a flag array.
		bchg	#\flag\&7, \array\+(\flag\>>3)

; Conditional long jump macros
jhi:				macro
		bls.b	.continue\@
		jmp		\1
.continue\@:
	endm

jls:				macro
		bhi.b	.continue\@
		jmp		\1
.continue\@:
	endm

jcc:				macro
		bcs.b	.continue\@
		jmp		\1
.continue\@:
	endm

jcs:				macro
		bcc.b	.continue\@
		jmp		\1
.continue\@:
	endm

jne:				macro
		beq.b	.continue\@
		jmp		\1
.continue\@:
	endm

jeq:				macro
		bne.b	.continue\@
		jmp		\1
.continue\@:
	endm

jpl:				macro
		bmi.b	.continue\@
		jmp		\1
.continue\@:
	endm

jmi:				macro
		bpl.b	.continue\@
		jmp		\1
.continue\@:
	endm

jge:				macro
		blt.b	.continue\@
		jmp		\1
.continue\@:
	endm

jlt:				macro
		bge.b	.continue\@
		jmp		\1
.continue\@:
	endm

jgt:				macro
		ble.b	.continue\@
		jmp		\1
.continue\@:
	endm

jle:				macro
		bgt.b	.continue\@
		jmp		\1
.continue\@:
	endm

; --------------------------------------------------

; --------------------------------------------------
; Z80
; --------------------------------------------------

; Clock speeds (Hz)
CLK_Z80_NTSC:	equ CLK_NTSC/15
CLK_Z80_PAL:	equ CLK_PAL/15

; RAM
Z80_RAM:	equ $A00000
Z80_RAM_LENGTH:	equ $2000
Z80_RAM_END:	equ Z80_RAM+Z80_RAM_LENGTH

; Z80 68k access bank
Z80_BANK:	equ $A06000					; 68k bank register.
Z80_68K:	equ $A08000
Z80_68K_LENGTH:	equ $8000
Z80_68K_END:	equ Z80_68K+Z80_68K_LENGTH

; Z80 bus
Z80_BUSREQ:	equ $A11100					; Z80 bus request line.
Z80_RESET:	equ $A11200					; Z80 reset line.

Z80_A_BIT:	equ 0						; Z80 assert bit.

Z80_RELEASE:	equ false<<Z80_A_BIT<<BYTE_WIDTH
Z80_ASSERT:	equ true<<Z80_A_BIT<<BYTE_WIDTH

; Z80 macros
z80_buson:	macros						; Releases the Z80 bus.
		move.w	#Z80_RELEASE, Z80_BUSREQ

z80_busoff:	macros						; Gets the Z80 bus.
		move.w	#Z80_ASSERT, Z80_BUSREQ

z80_buswait:	macro						; Waits for a Z80 bus request to be acknowledged.
.z80_wait\@:
		btst	#Z80_A_BIT, Z80_BUSREQ
		bne.b	.z80_wait\@
	endm

z80_reseton:	macros						; Releases the Z80 reset.
		move.w	#Z80_RELEASE, Z80_RESET

z80_resetoff:	macros						; Gets the Z80 reset.
		move.w	#Z80_ASSERT, Z80_RESET

; --------------------------------------------------

; --------------------------------------------------
; I/O
; --------------------------------------------------

; Registers
IO_SYSINFO:	equ $A10001					; System information register.

IO_P1DATA:	equ $A10003					; Joypad port 1 data (Parallel mode).
IO_P2DATA:	equ $A10005					; Joypad port 2 data (Parallel mode).
IO_P3DATA:	equ $A10007					; EXT port data (Parallel mode).
IO_P1CTRL:	equ $A10009					; Joypad port 1 control (Parallel mode).
IO_P2CTRL:	equ $A1000B					; Joypad port 2 control (Parallel mode).
IO_P3CTRL:	equ $A1000D					; EXT port control (Parallel mode).

IO_S1TXDATA:	equ $A1000F					; Joypad port 1 transceiver data (Serial mode).
IO_S1RXDATA:	equ $A10011					; Joypad port 1 receiver data (Serial mode).
IO_S1CTRL:	equ $A10013					; Joypad port 1 control (Serial mode).

IO_S2TXDATA:	equ $A10015					; Joypad port 2 transceiver data (Serial mode).
IO_S2RXDATA:	equ $A10017					; Joypad port 2 receiver data (Serial mode).
IO_S2CTRL:	equ $A10019					; Joypad port 2 control (Serial mode).

IO_S3TXDATA:	equ $A1001B					; EXT port transceiver data (Serial mode).
IO_S3RXDATA:	equ $A1001D					; EXT port receiver data (Serial mode).
IO_S3CTRL:	equ $A1001F					; EXT port control (Serial mode).

IO_MEMMODE:	equ $A11000					; Memory mode register.

IO_TIMEREG:	equ $A13000					; Cartridge /TIME signal registers.
IO_MARSSTR:	equ $A130EC					; 32X "MARS" connection string.
IO_SRAMFLAG:	equ $A130F1					; ROM/SRAM access toggle.

IO_ROMBANK1:	equ $A130F3					; ROM mapper bank pages.
IO_ROMBANK2:	equ $A130F5
IO_ROMBANK3:	equ $A130F7
IO_ROMBANK4:	equ $A130F9
IO_ROMBANK5:	equ $A130FB
IO_ROMBANK6:	equ $A130FD
IO_ROMBANK7:	equ $A130FF

IO_TMSSSTR:	equ $A14000					; TMSS "SEGA" string keyhole register.
IO_TMSSFLAG:	equ $A14101					; TMSS/catridge flag.

; System information flags
SYS_EXP_BIT:	equ 5						; Expansion unit disconnected flag.
SYS_PAL_BIT:	equ 6						; PAL clock speed flag.
SYS_OS_BIT:	equ 7						; Overseas region flag.

SYS_EXP:	equ false<<SYS_EXP_BIT				; Expansion unit connected.
SYS_NOEXP:	equ true<<SYS_EXP_BIT				; Expansion unit disconnected.

SYS_NTSC:	equ false<<SYS_PAL_BIT				; NTSC clock speed.
SYS_PAL:	equ true<<SYS_PAL_BIT				; PAL clock speed.

SYS_DOMESTIC:	equ false<<SYS_OS_BIT				; Domestic system region.
SYS_OVERSEAS:	equ true<<SYS_OS_BIT				; Overseas system region.

SYS_JP:		equ SYS_DOMESTIC|SYS_NTSC			; Japanese system.
SYS_US:		equ SYS_OVERSEAS|SYS_NTSC			; US system.
SYS_EU:		equ SYS_OVERSEAS|SYS_PAL			; European system.
SYS_SA:		equ SYS_DOMESTIC|SYS_PAL			; Only hypothetical, but would be used for South Asian territories like Thailand, Vietnam, and Malaysia.

; Joypad port bits
; Actual button values are defined by the input handler.
IO_D0_BIT:	equ 0
IO_D1_BIT:	equ 1
IO_D2_BIT:	equ 2
IO_D3_BIT:	equ 3
IO_TL_BIT:	equ 4
IO_TR_BIT:	equ 5
IO_TH_BIT:	equ 6
IO_HL_BIT:	equ 7

IO_D0:		equ true<<IO_D0_BIT
IO_D1:		equ true<<IO_D1_BIT
IO_D2:		equ true<<IO_D2_BIT
IO_D3:		equ true<<IO_D3_BIT
IO_TL:		equ true<<IO_TL_BIT
IO_TR:		equ true<<IO_TR_BIT
IO_TH:		equ true<<IO_TH_BIT
IO_HL:		equ true<<IO_HL_BIT

; --------------------------------------------------

; --------------------------------------------------
; VDP
; --------------------------------------------------

; Clock speeds (Hz)
CLK_VDP_NTSC:	equ CLK_NTSC/4					; VDP clock speed.
CLK_VDP_PAL:	equ CLK_PAL/4

CLK_PXL_NTSC:	equ CLK_VDP_NTSC/2				; VDP pixel clock speed.
CLK_PXL_PAL:	equ CLK_VDP_PAL/2

; Ports/registers
VDP_DATA:	equ $C00000					; VDP data port.
VDP_CTRL:	equ $C00004					; VDP control port.

VDP_HVCOUNT:	equ $C00008					; Horizontal/vertical scan-line counter.

VDP_DEBUGA0:	equ $C00018					; VDP debug register select.
VDP_DEBUGD0:	equ $C0001C					; VDP debug register data.

; VDP related lengths
TILE_LENGTH:	equ 32						; 32 bytes in an 8x8 4BPP tile.
TILE_COUNT:	equ 1024					; 1024 total tiles in VRAM. Not all of them are usable due to tables sharing VRAM.
VRAM_LENGTH:	equ $10000					; 64KB of VRAM. 128KB also available on Super-Target and System C.

COLOR_LENGTH:	equ word					; 1 word in a 9-bit BGR color.
COLOR_COUNT:	equ 64						; 64 total colors in CRAM.
PALETTE_LENGTH:	equ 16						; 16 colors in a palette.
PALETTE_COUNT:	equ 4						; 4 palettes in CRAM.
CRAM_LENGTH:	equ COLOR_COUNT*COLOR_LENGTH			; 128 bytes of CRAM.

SPRITE_LENGTH:	equ 8						; 8 bytes in a sprite, see sprite structure.
SPRITE_COUNT:	equ 80						; 80 sprites in a sprite table.
SPRTBL_LENGTH:	equ SPRITE_COUNT*SPRITE_LENGTH			; 640 bytes in a sprite table.

HSCROLL_LENGTH:	equ 256*2*word					; 256 scan-lines, 2 planes, word sized.
VSRAM_LENGTH:	equ 20*2*word					; 20 16-pixel wide columns, 2 planes, word sized.

; Display resolutions
DISP_H32:	equ 256
DISP_H40:	equ 320
DISP_V28:	equ 224
DISP_V30:	equ 240
DISP_V28I:	equ DISP_V28*2					; Interlace mode 2 vertical resolutions.
DISP_V30I:	equ DISP_V30*2

; VDP status register
VSR_PAL_BIT:	equ 0						; PAL VDP flag.
VSR_DMA_BIT:	equ 1						; DMA active flag.
VSR_HB_BIT:	equ 2						; H-blank active flag.
VSR_VB_BIT:	equ 3						; V-blank active flag.
VSR_ODD_BIT:	equ 4						; Even/odd interlace frame bit.
VSR_SC_BIT:	equ 5						; Sprite collision flag.
VSR_SL_BIT:	equ 6						; Sprite scan-line limit flag.
VSR_VI_BIT:	equ 7						; V-int triggered flag.
VSR_F_BIT:	equ 8						; FIFO empty flag.
VSR_E_BIT:	equ 9						; FIFO full flag.

VSR_NTSC:	equ false<<VSR_PAL_BIT				; NTSC VDP.
VSR_PAL:	equ true<<VSR_PAL_BIT				; PAL VDP.

VSR_DMA:	equ true<<VSR_DMA_BIT
VSR_HBLANK:	equ true<<VSR_HB_BIT
VSR_VBLANK:	equ true<<VSR_VB_BIT

VSR_EVEN:	equ false<<VSR_ODD_BIT				; Even frame.
VSR_ODD:	equ true<<VSR_ODD_BIT				; Odd frame.

VSCR_SPRCOL:	equ true<<VSR_SC_BIT
VSCR_SPRLIMIT:	equ true<<VSR_SL_BIT
VSCR_VINT:	equ true<<VSR_VI_BIT

VSR_EMPTY:	equ true<<VSR_E_BIT|false<<VSR_F_BIT		; FIFO is empty.
VSR_SOME:	equ false<<VSR_E_BIT|false<<VSR_F_BIT		; FIFO has some contents.
VSR_FULL:	equ false<<VSR_E_BIT|true<<VSR_F_BIT		; FIFO is full.
VSR_ERROR:	equ true<<VSR_E_BIT|true<<VSR_F_BIT		; Somehow, the FIFO is both empty and full.

; VDP registers
VREG_SET_BIT:	equ 15						; VDP register set flag.
VREG_REG_BIT:	equ 8						; VDP register number bit.

VREG_SET:	equ true<<VREG_SET_BIT

VREG_MODE1:	equ VREG_SET|0<<VREG_REG_BIT			; VDP mode 1 options register.
VREG_MODE2:	equ VREG_SET|1<<VREG_REG_BIT			; VDP mode 2 options register.
VREG_PLNAADDR:	equ VREG_SET|2<<VREG_REG_BIT			; Plane A nametable VRAM address.
VREG_WINADDR:	equ VREG_SET|3<<VREG_REG_BIT			; Window nametable VRAM address.
VREG_PLNBADDR:	equ VREG_SET|4<<VREG_REG_BIT			; Plane B nametable VRAM address.
VREG_SPRADDR:	equ VREG_SET|5<<VREG_REG_BIT			; Sprite table VRAM address.
VREG_SPRADDR2:	equ VREG_SET|6<<VREG_REG_BIT			; Sprite table 128KB VRAM address.
VREG_BGCOLOR:	equ VREG_SET|7<<VREG_REG_BIT			; Background color palette index.
VREG_HSCROLL:	equ VREG_SET|8<<VREG_REG_BIT			; Display mode 4 (SMS) horizontal scroll register.
VREG_VSCROLL:	equ VREG_SET|9<<VREG_REG_BIT			; Display mode 4 (SMS) vertical scroll register.
VREG_HINTRATE:	equ VREG_SET|10<<VREG_REG_BIT			; Horizontal interrupt scan-line rate.
VREG_MODE3:	equ VREG_SET|11<<VREG_REG_BIT			; VDP mode 3 options register.
VREG_MODE4:	equ VREG_SET|12<<VREG_REG_BIT			; VDP mode 4 options register.
VREG_HSCRADDR:	equ VREG_SET|13<<VREG_REG_BIT			; Horizontal scroll table VRAM address.
VREG_PLNADDR2:	equ VREG_SET|14<<VREG_REG_BIT			; Plane A and B 128KB VRAM addresses.
VREG_AUTOINC:	equ VREG_SET|15<<VREG_REG_BIT			; VDP read/write address auto-increment width.
VREG_PLNSIZE:	equ VREG_SET|16<<VREG_REG_BIT			; Plane map size.
VREG_WINXPOS:	equ VREG_SET|17<<VREG_REG_BIT			; Window plane X position.
VREG_WINYPOS:	equ VREG_SET|18<<VREG_REG_BIT			; Window plane Y position.
VREG_DMALENLO:	equ VREG_SET|19<<VREG_REG_BIT			; DMA operation length low byte.
VREG_DMALENHI:	equ VREG_SET|20<<VREG_REG_BIT			; DMA operation length high byte.
VREG_DMASRCLO:	equ VREG_SET|21<<VREG_REG_BIT			; DMA operation source address low byte.
VREG_DMASRCMID:	equ VREG_SET|22<<VREG_REG_BIT			; DMA operation source address middle byte.
VREG_DMASRCHI:	equ VREG_SET|23<<VREG_REG_BIT			; DMA operation source address high byte.

; VDP commands
VCMD_VRAM:	equ %100001
VCMD_CRAM:	equ %101011
VCMD_VSRAM:	equ %100101

VCMD_READ:	equ %001100
VCMD_WRITE:	equ %000111
VCMD_DMA:	equ %100111

; Tile/sprite rendering flags
VFLAG_H_BIT:	equ 11						; Horizontal flip flag.
VFLAG_V_BIT:	equ 12						; Vertical flip flag.
VFLAG_C_BIT:	equ 13						; Palette line bit.
VFLAG_P_BIT:	equ 15						; Priority flag.

VFLAG_HFLIP:	equ true<<VFLAG_H_BIT
VFLAG_VFLIP:	equ true<<VFLAG_V_BIT

VFLAG_PAL1:	equ 0<<VFLAG_C_BIT
VFLAG_PAL2:	equ 1<<VFLAG_C_BIT
VFLAG_PAL3:	equ 2<<VFLAG_C_BIT
VFLAG_PAL4:	equ 3<<VFLAG_C_BIT

VFLAG_PRIO:	equ true<<VFLAG_P_BIT

; Sprite structure
	rsreset
spr_ypos:	rs.w 1
spr_size:	rs.b 1
spr_link:	rs.b 1
spr_tile:	rs.w 1
spr_xpos:	rs.w 1
spr_end:	rs.b 0

; Sprite sizes
SPRSIZE_1X1:	equ 0<<2|0
SPRSIZE_1X2:	equ 0<<2|1
SPRSIZE_1X3:	equ 0<<2|2
SPRSIZE_1X4:	equ 0<<2|3
SPRSIZE_2X1:	equ 1<<2|0
SPRSIZE_2X2:	equ 1<<2|1
SPRSIZE_2X3:	equ 1<<2|2
SPRSIZE_2X4:	equ 1<<2|3
SPRSIZE_3X1:	equ 2<<2|0
SPRSIZE_3X2:	equ 2<<2|1
SPRSIZE_3X3:	equ 2<<2|2
SPRSIZE_3X4:	equ 2<<2|3
SPRSIZE_4X1:	equ 3<<2|0
SPRSIZE_4X2:	equ 3<<2|1
SPRSIZE_4X3:	equ 3<<2|2
SPRSIZE_4X4:	equ 3<<2|3

; Mode 1 options flags
VMD1_DD_BIT:	equ 0						; Disable display flag.
VMD1_LHV_BIT:	equ 1						; Latch H/V counter on external interrupt flag.
VMD1_M4_BIT:	equ 2						; Display mode 4 (SMS) flag. Should always be enabled.
VMD1_HI_BIT:	equ 4						; Horizontal interrupt enable flag.
VMD1_BLC_BIT:	equ 5						; Blank left-most tile column flag. For hiding tile refresh.

VMD1_DISPON:	equ false<<VMD1_DD_BIT				; Allow display.
VMD1_DISPOFF:	equ true<<VMD1_DD_BIT				; Disable display.

VMD1_LATCHHV:	equ true<<VMD1_LHV_BIT
VMD1_MODE4:	equ true<<VMD1_M4_BIT
VMD1_HINT:	equ true<<VMD1_HI_BIT
VMD1_BLANKCOL:	equ true<<VMD1_BLC_BIT

; Mode 2 options flags
VMD2_M5_BIT:	equ 2						; Display mode 5 (MD) flag.
VMD2_V30_BIT:	equ 3						; 30 tile tall display flag. PAL only.
VMD2_DMA_BIT:	equ 4						; DMA enable flag.
VMD2_VI_BIT:	equ 5						; Vertical interrupt enable flag.
VMD2_DE_BIT:	equ 6						; Enable display flag.
VMD2_128_BIT:	equ 7						; 128KB VRAM mode flag. Super-Target and System C only.

VMD2_SMS:	equ false<<VMD2_M5_BIT				; Display mode 4 (SMS).
VMD2_MD:	equ true<<VMD2_M5_BIT				; Display mode 5 (MD).

VMD2_V28:	equ false<<VMD2_V30_BIT				; 28 tile tall display.
VMD2_V30:	equ true<<VMD2_V30_BIT				; 30 tile tall display. PAL only.

VMD2_DMA:	equ true<<VMD2_DMA_BIT
VMD2_VINT:	equ true<<VMD2_VI_BIT

VMD2_DISPOFF:	equ false<<VMD2_DE_BIT				; Blank display with background color.
VMD2_DISPON:	equ true<<VMD2_DE_BIT				; Enable display rendering.

VMD2_64KB:	equ false<<VMD2_128_BIT				; 64KB VRAM.
VMD2_128KB:	equ true<<VMD2_128_BIT				; 128KB VRAM. Super-Target and System C only.

; Mode 3 options flags
VMD3_HS_BIT:	equ 0						; Horizontal scroll mode bit.
VMD3_VS_BIT:	equ 2						; 16-pixel wide vertical column scrolling flag.
VMD3_EI_BIT:	equ 3						; External interrupt enable flag.

VMD3_HSCRFULL:	equ %00<<VMD3_HS_BIT				; Horizontally scroll the full plane.
VMD3_HSCRTILE:	equ %10<<VMD3_HS_BIT				; Horizontally scroll tile sized rows.
VMD3_HSCRLINE:	equ %11<<VMD3_HS_BIT				; Horizontally scroll each scan-line.

VMD3_VSCRFULL:	equ false<<VMD3_VS_BIT				; Vertically scroll the full plane.
VMD3_VSCRCOL:	equ true<<VMD3_VS_BIT				; Vertically scroll 16-pixel wide columns.

VMD3_EXTINT:	equ true<<VMD3_EI_BIT

; Mode 4 options flags
VMD4_IL_BIT:	equ 1						; Interlacing mode bit.
VMD4_SH_BIT:	equ 3						; Shadow/highlight flag.
VMD4_PB_BIT:	equ 4						; Enable external pixel bus flag.
VMD4_PC_BIT:	equ 5						; Replace V-sync signal with pixel clock flag.
VMD4_FHS_BIT:	equ 6						; Freeze H-sync signal flag.

VMD4_H32:	equ %00000000					; 32 tile wide display.
VMD4_H40:	equ %10000001					; 40 tile wide display.

VMD4_INTOFF:	equ %00<<VMD4_IL_BIT				; Interlacing mode off.
VMD4_INTMD1:	equ %10<<VMD4_IL_BIT				; Interlacing mode 1 (Sub-pixel Y positioning).
VMD4_INTMD2:	equ %11<<VMD4_IL_BIT				; Interlacing mode 2 (Double tall resolution).

VMD4_SH:	equ true<<VMD4_SH_BIT
VMD4_PXLBUS:	equ true<<VMD4_PB_BIT

VMD4_VSYNC:	equ false<<VMD4_PC_BIT				; Use V-sync signal.
VMD4_PXLCLK:	equ true<<VMD4_PC_BIT				; Use pixel clock.

VMD4_FRZHS:	equ true<<VMD4_FHS_BIT

; Plane sizes
PLNSIZE_32X32:	equ %00<<4|%00
PLNSIZE_64X32:	equ %00<<4|%01
PLNSIZE_128X32:	equ %00<<4|%11
PLNSIZE_64X64:	equ %01<<4|%01
PLNSIZE_32X64:	equ %01<<4|%00
PLNSIZE_32X128:	equ %11<<4|%00

; DMA modes
DMAMD_BIT:	equ 6						; DMA mode bit.

DMAMD_TRANSFER:	equ %00<<DMAMD_BIT				; 68k to VDP transfer.
DMAMD_FILL:	equ %10<<DMAMD_BIT				; VRAM byte fill.
DMAMD_COPY:	equ %11<<DMAMD_BIT				; VRAM to VRAM copy.

; Nametables
PLNA_BIT:	equ 10						; Plane A nametable bit shift
WIN_BIT:	equ 10						; Window nametable bit shift.
PLNB_BIT:	equ 13						; Plane B nametable bit shift.
SPRTBL_BIT:	equ 9						; Sprite table bit shift.
SPRTBL_BIT2:	equ 11						; Sprite table 128KB VRAM bit shift.
HSCR_BIT:	equ 10						; Horizontal scroll table bit shift.
PLNA_BIT2:	equ 16						; Plane A 128KB VRAM nametable bit shift.
PLNB_BIT2:	equ 12						; Plane B 128KB VRAM nametable bit shift.

VRAM_PLNA:	equ $C000					; Default plane A nametable VRAM address.
VRAM_WIN:	equ $F000					; Default window nametable VRAM address.
VRAM_PLNB:	equ $E000					; Default plane B nametable VRAM address.
VRAM_SPR:	equ $D800					; Default sprite table VRAM address.
VRAM_HSCR:	equ $DC00					; Default horizontal scroll table VRAM address.

; Default colors
COLOR_BLACK:	equ $000
COLOR_WHITE:	equ $EEE

COLOR_RED:	equ $00E
COLOR_GREEN:	equ $0E0
COLOR_BLUE:	equ $E00

COLOR_CYAN:	equ $EE0
COLOR_YELLOW:	equ $0EE
COLOR_MAGENTA:	equ $E0E

; VDP command macro
vdp_cmd:	macro	type, rwd, addr, ctrl
	local	cmd
cmd:		equ ((((VCMD_\type\&VCMD_\rwd\)&3)<<30)|(((\addr)&$3FFF)<<WORD_WIDTH)|(((VCMD_\type\&VCMD_\rwd\)&$FC)<<2)|(((\addr)&$C000)>>14))
	if narg>3
		move.l	#$\$cmd, \ctrl
	else
		move.l	#$\$cmd, VDP_CTRL
	endif
	endm

; DMA macros
dma_transfer:	macro	type, src, addr, len, ctrl		; Transfer from 68k to the VDP.
	local	cmd
cmd:		equ ((((VCMD_\type\&VCMD_DMA)&3)<<30)|(((\addr)&$3FFF)<<WORD_WIDTH)|(((VCMD_\type\&VCMD_DMA)&$FC)<<2)|(((\addr)&$C000)>>14))
	local	lenreg
lenreg:		equ ((VREG_DMALENHI|((((\len)/word)&(BYTE_MAX<<BYTE_WIDTH))<<BYTE_WIDTH))|(VREG_DMALENLO|(((\len)/word)&BYTE_MAX)))
	local	srcreg
srcreg:		equ ((VREG_DMASRCMID|((((\src)/word)&(BYTE_MAX<<BYTE_WIDTH))<<BYTE_WIDTH))|(VREG_DMASRCLO|(((\src)/word)&BYTE_MAX)))
	local	mdreg
mdreg:		equ (VREG_DMASRCHI|DMAMD_TRANSFER|(((\src)>>17)&$7F))

	if narg>4
		move.l	#$\$lenreg, \ctrl
		move.l	#$\$srcreg, \ctrl
		move.w	#$\$mdreg, \ctrl
		move.w	#($\$cmd)>>WORD_WIDTH, \ctrl
		move.w	#($\$cmd)&WORD_MAX, -(sp)
		move.w	(sp)+, \ctrl
	else
		lea	VDP_CTRL, a6
		move.l	#$\$lenreg, (a6)
		move.l	#$\$srcreg, (a6)
		move.w	#$\$mdreg, (a6)
		move.w	#($\$cmd)>>WORD_WIDTH, (a6)
		move.w	#($\$cmd)&WORD_MAX, -(sp)
		move.w	(sp)+, (a6)
	endif
	endm

dma_fill:	macro	value, addr, len, ctrl			; Fill VRAM with byte value.
	local	lenreg
lenreg:		equ ((VREG_DMALENHI|((((\len)-1)&(BYTE_MAX<<BYTE_WIDTH))<<BYTE_WIDTH))|(VREG_DMALENLO|(((\len)-1)&BYTE_MAX)))

	if narg>3
		move.w	#VREG_AUTOINC|byte, \ctrl
		move.l	#$\$lenreg, \ctrl
		move.w	#VREG_DMASRCHI|DMAMD_FILL, \ctrl
		vdp_cmd	VRAM, DMA, \addr, \ctrl
	if instr("\ctrl", "(a")
		move.w	#\value\<<BYTE_WIDTH, -4\ctrl
	else
		move.w	#\value\<<BYTE_WIDTH, VDP_DATA
	endif
		dma_wait	\ctrl
		move.w	#VREG_AUTOINC|word, \ctrl
	else
		lea	VDP_CTRL, a6
		move.w	#VREG_AUTOINC|byte, (a6)
		move.l	#$\$lenreg, (a6)
		move.w	#VREG_DMASRCHI|DMAMD_FILL, (a6)
		vdp_cmd	VRAM, DMA, \addr, (a6)
		move.w	#\value\<<BYTE_WIDTH, -4(a6)
		dma_wait	(a6)
		move.w	#VREG_AUTOINC|word, (a6)
	endif
	endm

dma_copy:	macro	src, addr, len, ctrl			; Copy VRAM to VRAM.
	local	cmd
cmd:		equ ($000000C0|(((\addr)&$3FFF)<<16)|(((\addr)&$C000)>>14))
	local	lenreg
lenreg:		equ ((VREG_DMALENHI|((((\len)-1)&(BYTE_MAX<<BYTE_WIDTH))<<BYTE_WIDTH))|(VREG_DMALENLO|(((\len)-1)&BYTE_MAX)))
	local	srcreg
srcreg:		equ ((VREG_DMASRCMID|(((\src)&(BYTE_MAX<<BYTE_WIDTH))<<BYTE_WIDTH))|(VREG_DMASRCLO|((\src)&BYTE_MAX)))

	if narg>3
		move.w	#VREG_AUTOINC|byte, \ctrl
		move.l	#$\$lenreg, \ctrl
		move.l	#$\$srcreg, \ctrl
		move.w	#VREG_DMASRCHI|DMAMD_COPY, \ctrl
		move.l	#$\$cmd, \ctrl
		dma_wait	\ctrl
		move.w	#VREG_AUTOINC|word, \ctrl
	else
		lea	VDP_CTRL, a6
		move.w	#VREG_AUTOINC|byte, (a6)
		move.l	#$\$lenreg, (a6)
		move.l	#$\$srcreg, (a6)
		move.w	#VREG_DMASRCHI|DMAMD_COPY, (a6)
		move.l	#$\$cmd, (a6)
		dma_wait	(a6)
		move.w	#VREG_AUTOINC|word, (a6)
	endif
	endm

dma_wait:	macro	ctrl					; Wait for DMA to finish.
.dma_wait\@:
	if narg>0
		move.w	\ctrl, d7
	else
		move.w	VDP_CTRL, d7
	endif
		btst	#VSR_DMA_BIT, d7
		bne.b	.dma_wait\@
	endm

; --------------------------------------------------

; --------------------------------------------------
; Audio
; --------------------------------------------------

; Clock speeds (Hz)
CLK_YM_NTSC:	equ CLK_68K_NTSC				; YM-2612 clock speed.
CLK_YM_PAL:	equ CLK_68K_PAL

CLK_PSG_NTSC:	equ CLK_Z80_NTSC				; SN76496 clock speed.
CLK_PSG_PAL:	equ CLK_Z80_PAL

; Ports/registers
YM_A0:		equ $A04000					; FM global/channel 1-3 register select.
YM_D0:		equ $A04001					; FM global/channel 1-3 register data.
YM_A1:		equ $A04002					; FM global/channel 4-6 register select.
YM_D1:		equ $A04003					; FM global/channel 4-6 register data.

PSG_CTRL:	equ $C00011					; PSG control port.
PSG_Z80:	equ $A07F11					; Z80-side PSG control port.

; --------------------------------------------------

; ====================================================================================================

	endif

; ====================================================================================================
; End of file
; ====================================================================================================