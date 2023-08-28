(local {: path-join : realpath : symlink : unlink} (require :fs))
(local {: create-symlink : remove-symlink} (require :pieces.util))
(local {: is} (require :platform))
(import-macros {: match-platform} :platform-macros)

(fn src []
  (path-join *project* :config :mpv))

(fn dst []
  (path-join (os.getenv :HOME) :.config :mpv))

(var cdst nil)
(fn conf-dst []
  (if cdst
      cdst
      (path-join (os.getenv :HOME) :.config :mpv :mpv.conf)))

(fn conf-src []
  (match-platform
    linux (path-join *project* :config :mpv :mpv.conf.linux)
    macos (path-join *project* :config :mpv :mpv.conf.macos)))

(fn is-conf-managed [path]
  (or (= path (path-join *project* :config :mpv :mpv.conf.linux))
      (= path (path-join *project* :config :mpv :mpv.conf.macos))))

(fn conf-delete []
  (match (realpath (conf-dst))
    (nil _ :ENOENT) nil
    (nil err _) (error err)
    (real _ _)
      (if (is-conf-managed real)
          (do
            (io.stderr:write (.. "rm " (conf-dst) "\n"))
            (unlink (conf-dst)))
          (error (.. (conf-dst)
                     " is unmanaged, remove it manually to continue")))))

(fn conf-create []
  (match (realpath (conf-dst))
    (nil _ :ENOENT)
      (let [src (conf-src)]
        (io.stderr:write (.. "ln -s " src " -> " (conf-dst) "\n"))
        (symlink src (conf-dst)))
    (nil err _) (error err)
    (path _ _)
      (let [src (conf-src)]
        (when (not= path src)
          (when (not (is-conf-managed path))
            (error (.. (conf-dst)
                       " is unmanaged, remove it manually to continue")))
          (io.stderr:write (.. "rm " (conf-dst) "\n"))
          (unlink (conf-dst))
          (io.stderr:write (.. "ln -s " src " -> " (conf-dst) "\n"))
          (symlink src (conf-dst))))))

(fn up []
  (create-symlink (src) (dst))
  (conf-create))

(fn down []
  (conf-delete)
  (remove-symlink (src) (dst)))

{:cond is.unix
 : up
 : down}
