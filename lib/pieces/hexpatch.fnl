(local {: path-join : home} (require :fs))
(local {: create-symlink : remove-symlink} (require :pieces.util))
(import-macros {: match-platform} :platform-macros)

(fn src []
  (path-join *project* :config :HexPatch))

;; fnlfmt: skip
(fn dst []
  (match-platform
    windows (path-join (os.getenv :APPDATA) :HexPatch)
    macos (path-join (home) "Library/Application Support/HexPatch")
    unix (path-join (home) :.config :HexPatch)))

(fn up []
  (create-symlink (src) (dst) nil {:dir true}))

(fn down []
  (remove-symlink (src) (dst)))

{:cond true : up : down}

