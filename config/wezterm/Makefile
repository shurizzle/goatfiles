OUT     = wezterm.lua
SRC    := wezterm.fnl
FENNEL ?= fennel

all: $(OUT)

$(OUT): $(SRC)
	$(FENNEL) --require-as-include --skip-include wezterm -c $< > $@

.PHONY: all
