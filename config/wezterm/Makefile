include ../../fennel.mk

OUT     = wezterm.lua
SRC    := wezterm.fnl

all: $(OUT)

$(OUT): compile.fnl $(SRC)
	$(FENNEL) compile.fnl

clean:
	rm -f wezterm.lua

.PHONY: all
