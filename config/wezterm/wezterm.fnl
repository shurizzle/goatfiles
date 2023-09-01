(local wezterm (require :wezterm))
(local hostname (wezterm.hostname))
(local (arc os) (let [hostname (wezterm.hostname)
                      i1 (string.find wezterm.target_triple :-)
                      arch (string.sub wezterm.target_triple 1 (- i1 1))
                      i2 (string.find wezterm.target_triple :- (+ i1 1))
                      i3 (string.find wezterm.target_triple :- (+ i2 1))
                      os (if i3
                             (string.sub wezterm.target_triple (+ i2 1) (- i3 1))
                             (string.sub wezterm.target_triple (+ i2 1)))]
                  (values arch os)))

(set wezterm.GLOBAL.bells {})
(local *bell* "🔔")

(fn tab-title [tab max-width]
  (wezterm.truncate_right
    (.. (if (= (. wezterm.GLOBAL.bells (tostring tab.tab_id)) tab.tab_id) *bell* "")
        (string.gsub tab.active_pane.title "(.*: )(.*)" "%2"))
    (- max-width 2)))

(wezterm.on
  :format-tab-title
  (fn [tab _ _ _ _ max-width]
    (tset wezterm.GLOBAL.bells
          (tostring
            (: (: (wezterm.mux.get_window tab.window_id) :active_tab) :tab_id))
          nil)
    (.. " " (tab-title tab max-width) " ")))

(wezterm.on :bell (fn [window pane]
                    (let [tab (: (pane:tab) :tab_id)]
                      (when (not= (: (window:active_tab) :tab_id) tab)
                        (tset wezterm.GLOBAL.bells (tostring tab) tab)))))

(var config (if wezterm.config_builder (wezterm.config_builder) {}))

(set config.term "xterm-kitty")

(when (= os :windows)
  (set config.default_prog [:powershell]))

(fn ssh-domains []
  (let [ds (wezterm.default_ssh_domains)]
    (each [_ dom (ipairs ds)]
      (set dom.assume_shell :Posix))
    (each [_ name (ipairs [:vercingetorige :DomPerignon :filottete])]
      (when (not= name hostname)
        (table.insert ds {:name name
                          :remote_address (.. name :.local)
                          :multiplexing (if (= name :filottete) :None :WezTerm)
                          :assume_shell :Posix})))
    ds))
(set config.ssh_domains (ssh-domains))

(set config.mux_env_remove {})

(set config.front_end :WebGpu)

(set config.window_decorations (if (= os :linux) :NONE :RESIZE))
(set config.window_padding {:left 0
                            :right 0
                            :top 0
                            :bottom 0})
(set config.use_ime true)

(set config.enable_tab_bar true)
(set config.use_fancy_tab_bar false)
(set config.hide_tab_bar_if_only_one_tab true)
(set config.show_new_tab_button_in_tab_bar false)
(set config.show_tab_index_in_tab_bar false)
(set config.tab_bar_at_bottom true)

(set config.audible_bell :SystemBeep)
(set config.enable_wayland true)

(set config.allow_square_glyphs_to_overflow_width :Always)
(set config.harfbuzz_features [:ss01
                               :ss02
                               :ss03
                               :ss04
                               :ss05
                               :ss06
                               :zero
                               :onum])
(set config.font (wezterm.font_with_fallback ["CommitMono"
                                              "Hack Nerd Font Mono"
                                              "JetBrains Mono"
                                              "Noto Color Emoji"
                                              "Symbols Nerd Font Mono"]))
(set config.font_size (if (= os :linux) 10 11))

(set config.default_cursor_style :SteadyBar)

; (set config.enable_kitty_keyboard true)
(set config.enable_csi_u_key_encoding true)

(set config.colors {:background    :#282828
                    :foreground    :#eeeeee

                    :cursor_bg     :#ffffff
                    :cursor_fg     :#000000

                    :cursor_border :#ffffff

                    :ansi          [:#282828
                                    :#c8213d
                                    :#169C51
                                    :#DAAF19
                                    :#2F90FE
                                    :#C14ABE
                                    :#48C6DB
                                    :#CBCBCB]
                    :brights       [:#505050
                                    :#C7213D
                                    :#1ef15f
                                    :#FFE300
                                    :#00aeff
                                    :#FF40BE
                                    :#48FFFF
                                    :#ffffff]})

(local cpmods (if (= os :darwin) :CMD :CTRL|SHIFT))
(set config.disable_default_key_bindings true)
(set config.leader {:key :a :mods :CTRL :timeout_milliseconds 1000})

(fn common-keys []
  [{:key    :q
    :mods   :LEADER
    :action (wezterm.action.CloseCurrentPane {:confirm true})}
   {:key    :c
    :mods   :LEADER
    :action (wezterm.action.SpawnTab :CurrentPaneDomain)}
   {:key    :h
    :mods   :CTRL|LEADER
    :action (wezterm.action.ActivateTabRelative -1)}
    {:key    :l
     :mods   :CTRL|LEADER
     :action (wezterm.action.ActivateTabRelative 1)}
   {:key    :h
    :mods   :LEADER
    :action (wezterm.action.ActivatePaneDirection :Left)}
   {:key    :j
    :mods   :LEADER
    :action (wezterm.action.ActivatePaneDirection :Down)}
   {:key    :k
    :mods   :LEADER
    :action (wezterm.action.ActivatePaneDirection :Up)}
   {:key    :l
    :mods   :LEADER
    :action (wezterm.action.ActivatePaneDirection :Right)}
   {:key    :|
    :mods   :LEADER
    :action (wezterm.action.SplitHorizontal {:domain :CurrentPaneDomain})}
   {:key    :|
    :mods   :SHIFT|LEADER
    :action (wezterm.action.SplitHorizontal {:domain :CurrentPaneDomain})}
   {:key    :-
    :mods   :LEADER
    :action (wezterm.action.SplitVertical {:domain :CurrentPaneDomain})}
   {:key    " "
    :mods   :LEADER
    :action wezterm.action.ShowLauncher}
   {:key    :a
    :mods   :LEADER|CTRL
    :action (wezterm.action.SendString "\x01")}
   {:key    ::
    :mods   :SHIFT|LEADER
    :action wezterm.action.ShowDebugOverlay}
   {:key    ::
    :mods   :LEADER
    :action wezterm.action.ShowDebugOverlay}
   {:key    :v
    :mods   cpmods
    :action (wezterm.action.PasteFrom :Clipboard)}
   {:key    :c
    :mods   cpmods
    :action (wezterm.action.CopyTo :Clipboard)}])

(fn macos-keys []
  (if (= os :darwin)
      [{:key    ","
        :mods   :CTRL
        :action (wezterm.action.SendString "\27[44;5u")}
       {:key    ","
        :mods   :CTRL|SHIFT
        :action (wezterm.action.SendString "\27[44;6u")}]
      []))

(set config.keys (let [keys (common-keys)]
                   (each [_ k (ipairs (macos-keys))]
                     (table.insert keys k))
                   keys))

(set config.mouse_bindings [{:event {:Up {:streak 1 :button :Left}}
                             :mods :CTRL
                             :action wezterm.action.OpenLinkAtMouseCursor}])

config
