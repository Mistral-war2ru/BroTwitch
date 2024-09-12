-include config.mk

PROXY        = ed
LDFLAGS 	= -mdll -Wl,--enable-stdcall-fixup -Wl,--strip-all -Wl,--exclude-all-symbols
NFLAGS       = -f elf -Iinc/
CC            = gcc
CFLAGS       = -std=c99 -Iinc/
CPPFLAGS       = -masm=intel -Iinc/ -Os -mtune=i586


OBJS = dllmain.o
       
NASM        ?= nasm

.PHONY: default

%.o: %.asm
	$(NASM) $(NFLAGS) -o $@ $<

$(PROXY).dll: $(OBJS) modexp.def
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ -lstdc++ -static

clean:
	$(RM) $(OBJS) $(PROXY).dll
