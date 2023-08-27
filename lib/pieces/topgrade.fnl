(local {: path-join} (require :fs))
(local {: create-symlink : remove-symlink} (require :pieces.util))
(import-macros {: match-platform} :platform-macros)

(fn src []
  (match-platform
    linux (path-join *project* :config :topgrade.toml.arch-desktop)
    macos (path-join *project* :config :topgrade.toml.macos)))

(fn dst []
  (match-platform
    unix (path-join (os.getenv :HOME) :.config :topgrade.toml)))

(fn up []
  (create-symlink (src) (dst)))

(fn down []
  (remove-symlink (src) (dst)))

{:cond true
 : up
 : down}
