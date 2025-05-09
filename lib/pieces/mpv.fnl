(local {: path-join : realpath : symlink : unlink : home} (require :fs))
(local {: create-symlink : remove-symlink} (require :pieces.util))
(local {: is} (require :platform))
(import-macros {: match-platform} :platform-macros)

(local src (path-join *project* :config :mpv))
(local dst (path-join (home) :.config :mpv))

(local os-srcs (let [j #(path-join *project* :config :mpv (.. :mpv.conf. $1))]
                 {:linux (j :linux) :macos (j :macos)}))

;; fnlfmt: skip
(fn os-src []
  (match-platform
    linux os-srcs.linux
    macos os-srcs.macos))

(local os-dst (path-join dst :mpv.conf))

(fn up []
  (create-symlink src dst)
  (create-symlink (os-src) os-dst os-srcs))

(fn down []
  (remove-symlink (os-src) os-dst os-srcs)
  (remove-symlink src dst))

{:cond is.unix : up : down}

