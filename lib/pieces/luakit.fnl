(local {: path-join} (require :fs))
(local {: create-symlink : remove-symlink} (require :pieces.util))
(local {: is} (require :platform))

(fn up []
  (create-symlink (path-join *project* :config :luakit)
                  (path-join (os.getenv :HOME) :.config :luakit)))

(fn down []
  (remove-symlink (path-join *project* :config :luakit)
                  (path-join (os.getenv :HOME) :.config :luakit)))

{:cond is.linux
 : up
 : down}
