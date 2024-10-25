(local {: path-join} (require :fs))
(local {: create-symlink : remove-symlink} (require :pieces.util))
(import-macros {: match-platform} :platform-macros)

(fn src []
  (path-join *project* :config :HexPatch))

(fn dst []
  (match-platform windows (path-join (os.getenv :APPDATA) :HexPatch) macos
                  (path-join (os.getenv :HOME)
                             "Library/Application Support/HexPatch")
                  unix (path-join (os.getenv :HOME) :.config :HexPatch)))

(fn up []
  (create-symlink (src) (dst) nil {:dir true}))

(fn down []
  (remove-symlink (src) (dst)))

{:cond true : up : down}

