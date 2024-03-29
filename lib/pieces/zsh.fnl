(local {: path-join} (require :fs))
(local {: clone-git-repo : create-symlink} (require :pieces.util))
(local {: is} (require :platform))
(import-macros {: match-platform} :platform-macros)

(local git-url "git@github.com:shurizzle/zshrc.git")

(local dst (path-join (os.getenv :HOME) :.config :zsh))

(fn up []
  (clone-git-repo git-url dst [:--recursive])
  (create-symlink (path-join dst :profile)
                  (path-join (os.getenv :HOME) :.profile))
  (create-symlink (path-join dst :zprofile)
                  (path-join (os.getenv :HOME) :.zprofile))
  (create-symlink (path-join dst :zshrc)
                  (path-join (os.getenv :HOME) :.zshrc)))

{:cond is.unix
 : up}
