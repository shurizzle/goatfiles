(local {: path-join : home} (require :fs))
(local {: create-symlink : remove-symlink} (require :pieces.util))
(import-macros {: match-platform} :platform-macros)

(local src (path-join *project* :config :opencode))

;; fnlfmt: skip
(local dst
  (match-platform
    unix (path-join (home) :.config :opencode)
    windows (path-join (os.getenv :LOCALAPPDATA) :opencode)))

(fn up []
  (create-symlink src dst nil {:dir true}))

(fn down []
  (remove-symlink src dst))

{:cond true : up : down}
