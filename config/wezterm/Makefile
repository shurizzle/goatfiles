OUT     = wezterm.lua
SRC    := wezterm.fnl
FENNEL ?= fennel

all: $(OUT)

$(OUT): $(SRC)
	tmpfile="$$(mktemp)" && \
		echo "$$tmpfile" && \
		trap 'rm -rf "$$tmpfile"' EXIT && \
	  $(FENNEL) --require-as-include --skip-include wezterm -c $< > "$$tmpfile" && \
		mv "$$tmpfile" $@

.PHONY: all
