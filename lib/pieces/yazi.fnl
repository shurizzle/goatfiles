(local {: path-join : realpath : symlink : unlink} (require :fs))
(local {: create-symlink : remove-symlink} (require :pieces.util))
(local {: is} (require :platform))
(import-macros {: match-platform} :platform-macros)

(local src (path-join *project* :config :yazi))
(local dst (if is.win
               (path-join (os.getenv :HOME) :AppData :Roaming :yazi :config)
               (path-join (os.getenv :HOME) :.config :yazi)))

(fn up []
  (create-symlink src dst))

(fn down []
  (remove-symlink src dst))

{: up
 : down}
