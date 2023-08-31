(local {: path-join} (require :fs))
(local {: clone-git-repo} (require :pieces.util))
(import-macros {: match-platform} :platform-macros)

(local git-url "git@github.com:shurizzle/neovimmizzle.git")

(local dst
  (match-platform
    unix (path-join (os.getenv :HOME) :.config :nvim)))

(fn up []
  (clone-git-repo git-url dst))

{:cond true
 : up}

