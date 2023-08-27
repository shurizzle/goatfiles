(local {: path-join} (require :fs))
(local {: create-symlink : remove-symlink} (require :pieces.util))
(import-macros {: match-platform} :platform-macros)

(fn src []
  (path-join *project* :config :wezterm))

(fn dst []
  (match-platform
    (or linux bsd) (path-join (os.getenv :HOME) :.config :wezterm)))

(fn up []
  (create-symlink (src) (dst) {:dir true}))

(fn down []
  (remove-symlink (src) (dst)))

{:cond true
 : up
 : down}
