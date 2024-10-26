(local {: path-join} (require :fs))
(local {: create-symlink : remove-symlink} (require :pieces.util))
(local {: is} (require :platform))

(fn up []
  (each [_ v (ipairs [:2.0 :3.0])]
    (create-symlink (path-join *project* :config (.. :gtk- v))
                    (path-join (os.getenv :HOME) :.config (.. :gtk- v)))))

(fn down []
  (each [_ v (ipairs [:2.0 :3.0])]
    (remove-symlink (path-join *project* :config (.. :gtk- v))
                    (path-join (os.getenv :HOME) :.config (.. :gtk- v)))))

{:cond is.unix : up : down}

