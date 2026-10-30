include ../../fennel.mk

all: init.lua

init.lua: init.fnl
	$(FENNEL) --compile $< > $@

.PHONY: all
