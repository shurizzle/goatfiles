(local {: path-join} (require :fs))
(local {: create-symlink : remove-symlink} (require :pieces.util))
(import-macros {: match-platform} :platform-macros)

(fn src []
  (path-join *project* :config :contour))

;; fnlfmt: skip
(fn dst []
  (match-platform
    unix (path-join (os.getenv :HOME) :.config :contour)))

(fn up []
  (create-symlink (src) (dst) nil {:dir true}))

(fn down []
  (remove-symlink (src) (dst)))

{:cond true : up : down}

