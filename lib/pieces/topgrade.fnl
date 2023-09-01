(local {: path-join} (require :fs))
(local {: create-symlink : remove-symlink} (require :pieces.util))
(local {: is} (require :platform))
(import-macros {: match-platform} :platform-macros)

(local paths (let [j #(path-join *project* :config (.. :topgrade.toml. $1))]
               {:macos (j :macos)
                :linux (j :arch-desktop)}))

(fn src []
  (match-platform
    linux paths.linux
    macos paths.macos))

(fn dst []
  (match-platform
    unix (path-join (os.getenv :HOME) :.config :topgrade.toml)))

(fn up []
  (create-symlink (src) (dst) paths))

(fn down []
  (remove-symlink (src) (dst) paths))

{:cond is.unix
 : up
 : down}
