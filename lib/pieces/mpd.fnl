(local {: path-join} (require :fs))
(local {: create-symlink : remove-symlink} (require :pieces.util))
(local {: is} (require :platform))

(fn up []
  (create-symlink (path-join *project* :config :mpd)
                  (path-join (os.getenv :HOME) :.config :mpd)))

(fn down []
  (remove-symlink (path-join *project* :config :mpd)
                  (path-join (os.getenv :HOME) :.config :mpd)))

{:cond is.linux
 : up
 : down}
