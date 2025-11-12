.PHONY: all clean

ASM := ASM68K
ASMOPTS := /k /m /l /o ae- /o c+ /o v+ /o op+ /o os+ /o ow+ /o oz+ /o oaq+ /o osq+
LINKER := PSYLINK
LINKOPTS := /c /p /s /v
HEADERFIX := MDROMFIX
HEADEROPTS := -q -p 255

SRC := $(wildcard *.asm)
OBJ := $(patsubst %.asm,obj/%.obj,$(SRC))
ROM := rom.gen

all: $(ROM)

# Assemble every ASM file individually
obj/%.obj: %.asm
	@if not exist obj mkdir obj
	@echo Assembling $<
	ASM68K $(ASMOPTS) $<,obj\$*.obj,,obj\$*.lst

# Link ROM after all objects
$(ROM): link.lk $(OBJ)
	@echo Linking ROM...
	$(LINKER) $(LINKOPTS) @link.lk,$(ROM), output.sym, output.map
	$(HEADERFIX) $(HEADEROPTS) $(ROM)

clean:
	@if exist obj rmdir /s /q obj
	@del *.map *.sym 2>nul
	@del $(ROM) 2>nul