.PHONY: all clean

ASMOPTS := /k /m /l /o ae- /o c+ /o v+ /o op+ /o os+ /o ow+ /o oz+ /o oaq+ /o osq+
LINKOPTS := /c /p /s /v
HEADEROPTS := -q -p 255

SRC := $(wildcard src/*.s)
OBJ := $(patsubst src/%.s,obj/%.obj,$(SRC))
ROM := rom.gen

all: $(ROM)

# Assemble every ASM file individually
obj/%.obj: src/%.s src/*.inc
	@if not exist obj mkdir obj
	@echo Assembling $<
	asm68k $(ASMOPTS) $<,obj\$*.obj,,obj\$*.lst

# Link ROM after all objects
$(ROM): link.lk $(OBJ)
	@echo Linking ROM...
	psylink $(LINKOPTS) @link.lk,$(ROM), output.sym, output.map
	mdromfix $(HEADEROPTS) $(ROM)

clean:
	@if exist obj rmdir /s /q obj
	@del *.map *.sym 2>nul
	@del $(ROM) 2>nul

run: $(ROM)
	clownmdemu -c $(ROM)

flash: $(ROM)
	x7devkit $(ROM)