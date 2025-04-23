(local {: path-join : home} (require :fs))
(local {: create-symlink : remove-symlink} (require :pieces.util))
(import-macros {: match-platform} :platform-macros)
(local {: is} (require :platform))

(fn src []
  (path-join *project* :config :contour))

;; fnlfmt: skip
(fn dst []
  (match-platform
    unix (path-join (home) :.config :contour)))

(fn up []
  (create-symlink (src) (dst) nil {:dir true}))

(fn down []
  (remove-symlink (src) (dst)))

{:cond (not is.windows) : up : down}

