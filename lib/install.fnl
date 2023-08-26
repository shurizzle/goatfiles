(local {: create-symlink : remove-symlink : path-join} (require :fs))

(fn install-alacritty []
  (create-symlink (path-join *project* :config :alacritty)
                  (path-join (os.getenv :HOME) :.config :alacritty)))

(fn uninstall-alacritty []
  (remove-symlink (path-join *project* :config :alacritty)
                  (path-join (os.getenv :HOME) :.config :alacritty)))
