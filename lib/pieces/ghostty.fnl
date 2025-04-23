(local {: path-join : home} (require :fs))
(local {: create-symlink : remove-symlink} (require :pieces.util))
(local {: is} (require :platform))
(import-macros {: match-platform} :platform-macros)

(fn src []
  (path-join *project* :config :ghostty))

;; fnlfmt: skip
(fn dst []
  (match-platform
    macos (path-join (home) :Library "Application Support"
                     :com.mitchellh.ghostty)
    unix (path-join (home) :.config :ghostty)))

(fn up []
  (create-symlink (src) (dst) nil {:dir true}))

(fn down []
  (remove-symlink (src) (dst)))

{:cond (not is.windows) : up : down}

