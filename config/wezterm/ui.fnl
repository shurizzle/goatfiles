(local wezterm (require :wezterm))
(local {: is} (require :platform))

(local {:update update-bell : bell?} (require :bell))

(fn tab-title [tab max-width]
  (wezterm.truncate_right (.. (if (bell? tab.window_id tab.tab_id) "🔔" "")
                              (string.gsub tab.active_pane.title "(.*: )(.*)"
                                           "%2"))
                          (- max-width 2)))

(wezterm.on :format-tab-title
            (fn [tab _ _ _ _ max-width]
              (update-bell tab.window_id)
              (.. " " (tab-title tab max-width) " ")))

(var gh-match {:regex "[\"]?([\\w\\d]{2}[-\\w\\d]+)(/){1}([-\\w\\d\\.]+)[\"]?"
               :format "https://www.github.com/$1/$3"})

{:front_end (if (= :DomPerignon (wezterm.hostname)) :OpenGL :WebGpu)
 :window_decorations (if is.linux
                         (if (os.getenv :WAYLAND_DISPLAY) :RESIZE :NONE)
                         :RESIZE)
 :window_padding {:left 0 :right 0 :top 0 :bottom 0}
 :use_ime true
 :ime_preedit_rendering :System
 :enable_tab_bar true
 :use_fancy_tab_bar false
 :hide_tab_bar_if_only_one_tab true
 :show_new_tab_button_in_tab_bar false
 :show_tab_index_in_tab_bar false
 :tab_bar_at_bottom true
 :audible_bell :SystemBeep
 :enable_wayland true
 :default_cursor_style :SteadyBar
 :hyperlink_rules (merge! (wezterm.default_hyperlink_rules) [gh-match])}

