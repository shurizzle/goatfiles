include ../../fennel.mk

OUT     = wezterm.lua
SRC    := wezterm.fnl

all: $(OUT)

$(OUT): compile.fnl $(SRC)
	$(FENNEL) compile.fnl

.PHONY: all
