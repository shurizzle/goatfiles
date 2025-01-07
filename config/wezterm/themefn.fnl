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

(fn colorscheme [?appearance]
  (if (: (or ?appearance (get-appearance)) :match :Light)
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

(local render-state (if (= :DomPerignon (wezterm.hostname))
                        (fn [] nil)
                        (fn [light? state]
                          (fn decorate [f]
                            (let [base [(base-background (if light? white black))]]
                              (when f
                                (table.insert base (f light?)))
                              base))

                          (case state
                            (where :kamui) (decorate ryukomatoi-kamui)
                            (where :sailor) (decorate ryukomatoi-sailor)
                            _ (decorate)))))

(fn render-background [?appearance state]
  (let [light? (: (or ?appearance (get-appearance)) :match :Light)]
    (render-state light? (or state :kamui))))

(fn rotate-background [window]
  (when (not wezterm.GLOBAL.backgrounds)
    (set wezterm.GLOBAL.backgrounds []))
  (let [appearance (window:get_appearance)
        light? (appearance:match :Light)
        id (tostring (window:window_id))
        state (match (or (. wezterm.GLOBAL.backgrounds id) :kamui)
                (where :kamui) :sailor
                (where :sailor) :none
                (where :none) :kamui)
        overrides (or (window:get_config_overrides) [])]
    (tset wezterm.GLOBAL.backgrounds id state)
    (set overrides.background
         (render-state light? (. wezterm.GLOBAL.backgrounds id)))
    (window:set_config_overrides overrides)
    nil))

(wezterm.on :window-config-reloaded
            (fn [window _]
              (local overrides (or (window:get_config_overrides) []))
              (local appearance (window:get_appearance))
              (set overrides.color_scheme (colorscheme appearance))
              (set overrides.background
                   (render-background appearance
                                      (. (or wezterm.GLOBAL.backgrounds [])
                                         (tostring (window:window_id)))))
              (window:set_config_overrides overrides)))

{: rotate-background : render-background : colorscheme : dark : light}

