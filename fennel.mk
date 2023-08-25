GOATFILES_ROOT := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
BUNDLED_FENNEL_BIN := $(GOATFILES_ROOT)fennel

# ifeq (, $(FENNELUV))
# $(shell fennel -e "(require :luv)" 2>/dev/null >/dev/null)
# ifeq (0, $(.SHELLSTATUS))
# FENNELUV := $(shell which fennel)
# endif
# endif
#
# ifeq (, $(LUAUV))
# $(shell luajit -e "require'luv'" 2>/dev/null >/dev/null)
# ifeq (0, $(.SHELLSTATUS))
# LUAUV := $(shell which luajit)
# endif
# endif
#
# ifeq (, $(LUAUV))
# $(shell lua -e "require'luv'" 2>/dev/null >/dev/null)
# ifeq (0, $(.SHELLSTATUS))
# LUAUV := $(shell which lua)
# endif
# endif
#
# ifeq (, $(LUAUV))
# LUAUV := $(shell which nvim) -u NONE --headless -l $(BUNDLED_FENNEL_BIN)
# ifeq (0, $(.SHELLSTATUS))
# $(error "No fennel/lua/luajit with luv or neovim in PATH")
# endif
# endif
#
# ifeq (, $(FENNELUV))
# FENNELUV := $(LUAUV) $(BUNDLED_FENNEL_BIN)
# endif

ifeq (, $(FENNEL))
FENNEL := $(shell which fennel)
endif

ifeq (, $(FENNEL))
ifneq (, $(shell which luajit))
FENNEL := luajit $(BUNDLED_FENNEL_BIN)
else ifneq (, $(shell which lua))
FENNEL := lua $(BUNDLED_FENNEL_BIN)
else ifneq (, $(shell which nvim))
FENNEL := nvim -u NONE --headless -l $(BUNDLED_FENNEL_BIN)
else
$(error "No fennel or lua/luajit/neovim in PATH")
endif
endif
