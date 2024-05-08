(local wezterm (require :wezterm))

(set wezterm.GLOBAL.bells {})

(fn update [win-id]
  (-?> (. wezterm.GLOBAL.bells (tostring win-id))
       (tset (tostring (-> (wezterm.mux.get_window win-id)
                           (: :active_tab)
                           (: :tab_id))) nil)))

(wezterm.on :bell (fn [window pane]
                    (when (os.getenv :WAYLAND_DISPLAY)
                      (wezterm.background_child_process [:paplay
                                                         :/usr/share/sounds/freedesktop/stereo/bell.oga]))
                    (let [win-id (window:window_id)
                          tab-id (: (pane:tab) :tab_id)]
                      (when (not= (: (window:active_tab) :tab_id) tab-id)
                        (tset wezterm.GLOBAL.bells (tostring win-id)
                              (or (. wezterm.GLOBAL.bells (tostring win-id)) []))
                        (tset (. wezterm.GLOBAL.bells (tostring win-id))
                              (tostring tab-id) tab-id)))))

(fn bell? [win-id tab-id]
  (= (?. wezterm.GLOBAL.bells (tostring win-id) (tostring tab-id)) tab-id))

{: update : bell?}
