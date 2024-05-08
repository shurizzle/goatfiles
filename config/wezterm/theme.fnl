(local wezterm (require :wezterm))

(local black "#282828")
(local white "#eeeeee")
(local ansi ["#282828"
             "#c8213d"
             "#169C51"
             "#DAAF19"
             "#2F90FE"
             "#C14ABE"
             "#48C6DB"
             "#CBCBCB"])

(local brights ["#505050"
                "#C7213D"
                "#1ef15f"
                "#FFE300"
                "#00aeff"
                "#FF40BE"
                "#48FFFF"
                "#ffffff"])

(local visual_bell "#FFE300")

(local dark {:background black
             :foreground white
             :cursor_bg white
             :cursor_fg black
             :cursor_border white
             : ansi
             : brights
             : visual_bell})

(local light {:background white
              :foreground black
              :cursor_bg black
              :cursor_fg white
              :cursor_border black
              : ansi
              : brights
              : visual_bell})

(fn get-appearance []
  (if wezterm.gui
      (wezterm.gui.get_appearance) :Dark))

(fn colorscheme [appearance]
  (if (: (or appearance (get-appearance)) :match :Light)
      "BlueSky Light"
      "BlueSky Dark"))

(fn ryukomatoi-sailor [light?]
  {:source {:File (.. (os.getenv :HOME)
                      :/Pictures/imgbin_ryuko-matoi-senketsu-manga-anime-mako-mankanshoku-png.png)}
   :width (.. (/ 1024 5) :px)
   :height (.. (/ 1078 5) :px)
   :repeat_x :NoRepeat
   :repeat_y :NoRepeat
   :vertical_align :Bottom
   :horizontal_align :Right
   :opacity (if light? 0.5 0.1)})

(fn ryukomatoi-kamui [light?]
  {:source {:File (.. (os.getenv :HOME)
                      :/Pictures/imgbin_ryuko-matoi-senketsu-desktop-png.png)}
   :width (.. (/ 8000 40) :px)
   :height (.. (/ 7646 40) :px)
   :repeat_x :NoRepeat
   :repeat_y :NoRepeat
   :vertical_align :Bottom
   :horizontal_align :Right
   :opacity (if light? 0.5 0.1)})

(fn base-background [Color] {:source {: Color} :width "100%" :height "100%"})

(fn background [appearance]
  (let [light? (: (or appearance (get-appearance)) :match :Light)]
    [(base-background (if light? white black)) (ryukomatoi-sailor light?)]))

(wezterm.on :window-config-reloaded
            (fn [window pane]
              (local overrides (or (window:get_config_overrides) []))
              (local appearance (window:get_appearance))
              (set overrides.color_scheme (colorscheme appearance))
              (set overrides.background (background appearance))
              (window:set_config_overrides overrides)))

{:color_scheme (colorscheme)
 :color_schemes {"BlueSky Dark" dark "BlueSky Light" light}
 :background (background)}

