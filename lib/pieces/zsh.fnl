(local {: path-join : home} (require :fs))
(local {: clone-git-repo : create-symlink} (require :pieces.util))
(local {: is} (require :platform))
(import-macros {: match-platform} :platform-macros)
(local *home* (home))

(local git-url "git@github.com:shurizzle/zshrc.git")

(local dst (path-join *home* :.config :zsh))

(fn up []
  (clone-git-repo git-url dst [:--recursive])
  (create-symlink (path-join dst :profile)
                  (path-join *home* :.profile))
  (create-symlink (path-join dst :zprofile)
                  (path-join *home* :.zprofile))
  (create-symlink (path-join dst :zshrc)
                  (path-join *home* :.zshrc)))

{:cond is.unix
 : up}
