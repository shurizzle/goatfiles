(local {: path-join} (require :fs))
(local {: create-symlink : remove-symlink : need-cmds} (require :pieces.util))
(local {: exec} (require :os-util))
(import-macros {: match-platform} :platform-macros)

(local src (path-join *project* :config :fontconfig))

(local dst (match-platform
             unix (path-join (os.getenv :HOME) :.config :fontconfig)))

(fn up []
  (need-cmds :fc-cache)
  (create-symlink src dst nil {:dir true})
  (exec :fc-cache {:args [:-fv]}))

(fn down []
  (need-cmds :fc-cache)
  (remove-symlink (src) (dst))
  (exec :fc-cache {:args [:-fv]}))

{:cond true
 : up
 : down}
