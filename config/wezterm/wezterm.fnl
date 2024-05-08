(include :stdlib)

(local wezterm (require :wezterm))
(local {: is} (require :platform))

(var config (if wezterm.config_builder (wezterm.config_builder) {}))

;; (set config.term "xterm-kitty")

(when is.windows
  (set config.default_prog [:pwsh]))

(set config.mux_env_remove {})
(set config.enable_kitty_keyboard true)
(set config.enable_csi_u_key_encoding true)

(macro import! [name]
  `(merge! config (pick-values 1 (require ,name))))

(import! :domains)
(import! :font)
(import! :ui)
(import! :theme)
(import! :keys)

config
