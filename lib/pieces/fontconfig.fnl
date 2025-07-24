(local {: path-join : home} (require :fs))
(local {: create-symlink : remove-symlink : need-cmds} (require :pieces.util))
(local {: exec} (require :os-util))
(local {: is} (require :platform))

(local src (path-join *project* :config :fontconfig))

(local dst (path-join (home) :.config :fontconfig))

(fn up []
  (need-cmds :fc-cache)
  (create-symlink src dst nil {:dir true})
  (exec :fc-cache {:args [:-fv]}))

(fn down []
  (need-cmds :fc-cache)
  (remove-symlink src dst)
  (exec :fc-cache {:args [:-fv]}))

{:cond (and is.unix (not is.mac)) : up : down}

