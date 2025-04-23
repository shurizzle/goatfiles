(local {: path-join : realpath : symlink : unlink : home : dirname : mkdir} (require :fs))
(local {: create-symlink : remove-symlink} (require :pieces.util))
(local {: is} (require :platform))
(import-macros {: match-platform} :platform-macros)

(local src (path-join *project* :config :yazi))
(local dst (if is.win
               (path-join (home) :AppData :Roaming :yazi :config)
               (path-join (home) :.config :yazi)))

(fn up []
  (mkdir (dirname dst) (tonumber "660" 8))
  (create-symlink src dst))

(fn down []
  (remove-symlink src dst))

{: up : down}

