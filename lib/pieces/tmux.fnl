(local {: path-join : home} (require :fs))
(local {: create-symlink : remove-symlink} (require :pieces.util))
(local {: is} (require :platform))
(import-macros {: match-platform} :platform-macros)

(local src (path-join *project* :config :tmux))
(local dst (path-join (home) :.config :tmux))

(fn up []
  (create-symlink src dst)
  (create-symlink (path-join dst :tmux.conf)
                  (path-join (home) :.tmux.conf)
                  [(path-join *project* :config :tmux :tmux.conf)]))

(fn down []
  (remove-symlink (path-join dst :tmux.conf)
                  (path-join (home) :.tmux.conf))
  (remove-symlink src dst))

{:cond is.unix : up : down}

