(local {: create-symlink : remove-symlink : path-join} (require :fs))
(local {: is} (require :platform))

(fn up []
  (create-symlink (path-join *project* :config :alacritty)
                  (path-join (os.getenv :HOME) :.config :alacritty)))

(fn down []
  (remove-symlink (path-join *project* :config :alacritty)
                  (path-join (os.getenv :HOME) :.config :alacritty)))

{:cond is.unix
 : up
 : down}
