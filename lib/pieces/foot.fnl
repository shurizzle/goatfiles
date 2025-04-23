(local {: path-join : home} (require :fs))
(local {: create-symlink : remove-symlink} (require :pieces.util))
(local {: is} (require :platform))
(import-macros {: match-platform} :platform-macros)

(fn src []
  (path-join *project* :config :foot))

;; fnlfmt: skip
(fn dst []
  (match-platform
    unix (path-join (home) :.config :foot)))

(fn up []
  (create-symlink (src) (dst) nil {:dir true}))

(fn down []
  (remove-symlink (src) (dst)))

{:cond (and is.unix (not is.macos)) : up : down}

