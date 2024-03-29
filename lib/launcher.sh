LIB="$SCRIPTPATH/lib/launcher.fnl"
FENNEL="$SCRIPTPATH/fennel"
GLOBALS='*file*,*project*,pattern-quote,unpack'

if fennel -e '(require :luv)' 2>/dev/null >/dev/null; then
  fennel --globals "$GLOBALS" "$LIB" "$ACTION" "$@"
elif lua -e "require'luv'" 2>/dev/null >/dev/null; then
  lua "$FENNEL" --globals "$GLOBALS" "$LIB" "$ACTION" "$@"
elif luajit -e "require'luv'" 2>/dev/null >/dev/null; then
  luajit "$FENNEL" --globals "$GLOBALS" "$LIB" "$ACTION" "$@"
elif which nvim 2>/dev/null >/dev/null; then
  nvim -u NONE --headless -l "$FENNEL" --globals "$GLOBALS" "$LIB" "$ACTION" "$@"
else
  echo "Cannot find a valid lua version with luv support" >&2
  exit 1
fi
