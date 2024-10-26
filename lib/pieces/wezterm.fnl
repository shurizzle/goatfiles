(local {: path-join} (require :fs))
(local {: create-symlink : remove-symlink} (require :pieces.util))
(import-macros {: match-platform} :platform-macros)

(fn src []
  (path-join *project* :config :wezterm))

;; fnlfmt: skip
(fn dst []
  (match-platform
    unix (path-join (os.getenv :HOME) :.config :wezterm)
    windows (path-join (os.getenv :userprofile) :.config :wezterm)))

(fn up []
  (create-symlink (src) (dst) nil {:dir true}))

(fn down []
  (remove-symlink (src) (dst)))

{:cond true : up : down}

