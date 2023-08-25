ifeq (, $(FENNEL))
FENNEL := $(shell which fennel)
endif

ifeq (, $(FENNEL))
ifneq (, $(shell which luajit))
FENNEL := luajit $(dir $(abspath $(lastword $(MAKEFILE_LIST))))fennel
else ifneq (, $(shell which lua))
FENNEL := lua $(dir $(abspath $(lastword $(MAKEFILE_LIST))))fennel
else
$(error "No fennel or lua/luajit in PATH")
endif
endif
