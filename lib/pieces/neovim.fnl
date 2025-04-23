(local {: path-join : home} (require :fs))
(local {: clone-git-repo} (require :pieces.util))
(import-macros {: match-platform} :platform-macros)

(local git-url "git@github.com:shurizzle/neovimmizzle.git")

;; fnlfmt: skip
(local dst
  (match-platform
    unix (path-join (home) :.config :nvim)
    windows (path-join (os.getenv :LOCALAPPDATA) :nvim)))

(fn up []
  (clone-git-repo git-url dst))

{:cond true : up}

