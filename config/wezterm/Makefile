include ../../fennel.mk

OUT     = wezterm.lua
SRC    := wezterm.fnl bell.fnl compile.fnl domains.fnl flsproject.fnl font.fnl \
					keys.fnl platform.fnl stdlib.fnl theme.fnl themefn.fnl ui.fnl

all: $(OUT)

$(OUT): compile.fnl $(SRC)
	$(FENNEL) compile.fnl

clean:
	rm -f wezterm.lua

.PHONY: all
