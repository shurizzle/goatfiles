(local {: path-join} (require :fs))
(local {: create-symlink : remove-symlink} (require :pieces.util))
(local {: is} (require :platform))
(import-macros {: match-platform} :platform-macros)

(local src (path-join *project* :config :tmux :tmux.conf))

(local dst (match-platform
             unix (path-join (os.getenv :HOME) :.tmux.conf)))

(fn up []
  (create-symlink src dst))

(fn down []
  (remove-symlink src dst))

{:cond is.unix
 : up
 : down}
