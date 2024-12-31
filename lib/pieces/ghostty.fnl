(local {: path-join} (require :fs))
(local {: create-symlink : remove-symlink} (require :pieces.util))
(import-macros {: match-platform} :platform-macros)

(fn src []
  (path-join *project* :config :ghostty))

;; fnlfmt: skip
(fn dst []
  (match-platform
    macos (path-join (os.getenv :HOME) :Library "Application Support"
                     :com.mitchellh.ghostty)
    unix (path-join (os.getenv :HOME) :.config :ghostty)))

(fn up []
  (create-symlink (src) (dst) nil {:dir true}))

(fn down []
  (remove-symlink (src) (dst)))

{:cond true : up : down}

