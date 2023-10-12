(local wezterm (require :wezterm))

(local black :#282828)
(local white :#eeeeee)
(local ansi [:#282828
             :#c8213d
             :#169C51
             :#DAAF19
             :#2F90FE
             :#C14ABE
             :#48C6DB
             :#CBCBCB])
(local brights [:#505050
                :#C7213D
                :#1ef15f
                :#FFE300
                :#00aeff
                :#FF40BE
                :#48FFFF
                :#ffffff])
(local visual_bell :#FFE300)

(local dark {:background    black
             :foreground    white
             :cursor_bg     white
             :cursor_fg     black
             :cursor_border white
             : ansi
             : brights
             : visual_bell})

(local light {:background    white
              :foreground    black
              :cursor_bg     black
              :cursor_fg     white
              :cursor_border black
              : ansi
              : brights
              : visual_bell})

(fn get-appearance []
  (if wezterm.gui
      (wezterm.gui.get_appearance)
      :Dark))

(fn colorscheme [appearance]
  (if (: (or appearance (get-appearance)) :match :Light)
      "BlueSky Light"
      "BlueSky Dark"))

(wezterm.on
  :window-config-reloaded
  (fn [window pane]
    (local overrides (or (window:get_config_overrides) []))
    (local scheme (colorscheme (window:get_appearance)))
    (when (not= overrides.color_scheme scheme)
      (set overrides.color_scheme scheme)
      (window:set_config_overrides overrides))))

{:color_scheme  (colorscheme)
 :color_schemes {"BlueSky Dark"  dark
                 "BlueSky Light" light}}
