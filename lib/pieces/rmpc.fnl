(local {: path-join : home} (require :fs))
(local {: create-symlink : remove-symlink} (require :pieces.util))
(local {: is} (require :platform))
(import-macros {: match-platform} :platform-macros)

(fn src []
  (path-join *project* :config :rmpc))

(fn dst []
  (match-platform unix (path-join (home) :.config :rmpc)))

(fn up []
  (create-symlink (src) (dst) nil {:dir true}))

(fn down []
  (remove-symlink (src) (dst)))

{:cond is.unix : up : down}

