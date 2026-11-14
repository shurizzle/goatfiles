(local wezterm (require :wezterm))
(local act wezterm.action)
(local {: is} (require :platform))

(fn readable? [path]
  (case (io.open path)
    f (do
        (f:close)
        true)
    _ false))

;; shortcut: checks the GUI process PATH, not the remote one for non-local domains.
(fn in-path? [bin]
  (if (not is.windows)
      ;; Lua can't check the exec bit; `command -v` resolves PATH and requires +x
      (wezterm.run_child_process [:sh :-c "command -v \"$1\"" :sh bin])
      (bin:find "[/\\]")
      (readable? bin)
      ;; where.exe resolves PATH + PATHEXT; exit code 0 when found
      (wezterm.run_child_process [:where.exe :/Q bin])))

;; Spawn a tab right after the active one instead of at the end.
;; Each arg is a spawn_tab options table; the first whose command is
;; found in PATH wins (spawn_tab doesn't raise on a missing binary:
;; it opens a tab showing the error instead).
(fn spawn-tab-right [...]
  (let [candidates (if (= 0 (select :# ...)) [{}] [...])]
    (wezterm.action_callback (fn [win pane]
                               (let [mux-win (win:mux_window)
                                     idx (accumulate [i 0 _ t (ipairs (mux-win:tabs_with_info))]
                                           (if t.is_active t.index i))
                                     domain {:DomainName (pane:get_domain_name)}]
                                 (var (tab new-pane err) nil)
                                 (set err "no spawn candidate found in PATH")
                                 (each [_ opts (ipairs candidates) &until tab]
                                   (when (or (nil? opts.args)
                                             (in-path? (. opts.args 1)))
                                     (set opts.domain domain)
                                     (case (pcall mux-win.spawn_tab mux-win
                                                  opts)
                                       (true t p) (set (tab new-pane)
                                                       (values t p))
                                       (false e) (set err e))))
                                 (if tab
                                     (do
                                       (tab:activate)
                                       (win:perform_action (act.MoveTab (+ idx
                                                                           1))
                                                           new-pane))
                                     (wezterm.log_error err)))))))

(local set-default-domain
       (wezterm.action_callback (fn [_ _ id]
                                  (when id
                                    (wezterm.mux.set_default_domain (wezterm.mux.get_domain id))))))

;; Pick the mux default domain (used by DefaultDomain spawns) for this GUI.
(local choose-default-domain
       (wezterm.action_callback (fn [win pane]
                                  (let [current (: (wezterm.mux.get_domain)
                                                   :name)]
                                    (win:perform_action (act.InputSelector {:title "Default domain"
                                                                            :fuzzy true
                                                                            :action set-default-domain
                                                                            :choices (icollect [_ d (ipairs (wezterm.mux.all_domains))]
                                                                                       (when (d:is_spawnable)
                                                                                         {:id (d:name)
                                                                                          :label (if (= (d:name)
                                                                                                        current)
                                                                                                     (.. (d:name)
                                                                                                         " *")
                                                                                                     (d:name))}))})
                                                        pane)))))

(fn common-keys []
  [{:key :q :mods :LEADER :action (act.CloseCurrentPane {:confirm true})}
   {:key :c :mods :LEADER :action (spawn-tab-right)}
   {:key :h :mods :CTRL|LEADER :action (act.ActivateTabRelative -1)}
   {:key :l :mods :CTRL|LEADER :action (act.ActivateTabRelative 1)}
   {:key :h :mods :LEADER :action (act.ActivatePaneDirection :Left)}
   {:key :j :mods :LEADER :action (act.ActivatePaneDirection :Down)}
   {:key :k :mods :LEADER :action (act.ActivatePaneDirection :Up)}
   {:key :l :mods :LEADER :action (act.ActivatePaneDirection :Right)}
   {:key :b
    :mods :LEADER
    :action (wezterm.action_callback (. (require :themefn) :rotate-background))}
   {:key "|"
    :mods :LEADER
    :action (act.SplitHorizontal {:domain :CurrentPaneDomain})}
   {:key "|"
    :mods :SHIFT|LEADER
    :action (act.SplitHorizontal {:domain :CurrentPaneDomain})}
   {:key "-"
    :mods :LEADER
    :action (act.SplitVertical {:domain :CurrentPaneDomain})}
   {:key " " :mods :LEADER :action act.ShowLauncher}
   {:key :s
    :mods :LEADER
    :action (act.ShowLauncherArgs {:flags :FUZZY|WORKSPACES})}
   {:key :d :mods :LEADER :action choose-default-domain}
   {:key :a :mods :LEADER|CTRL :action (act.SendString "\001")}
   {:key ":" :mods :SHIFT|LEADER :action act.ShowDebugOverlay}
   {:key :v :mods :LEADER :action act.ActivateCopyMode}
   {:key "/" :mods :LEADER :action (act.Search {:CaseInSensitiveString ""})}
   {:key ":" :mods :LEADER :action act.ShowDebugOverlay}
   {:key :v :mods :CTRL|SHIFT :action (act.PasteFrom :Clipboard)}
   {:key :c :mods :CTRL|SHIFT :action (act.CopyTo :Clipboard)}
   {:key "<" :mods :LEADER :action (act.MoveTabRelative -1)}
   {:key ">" :mods :LEADER :action (act.MoveTabRelative 1)}
   {:key "<" :mods :LEADER|SHIFT :action (act.MoveTabRelative -1)}
   {:key ">" :mods :LEADER|SHIFT :action (act.MoveTabRelative 1)}
   {:key "=" :mods :CTRL :action act.IncreaseFontSize}
   {:key "-" :mods :CTRL :action act.DecreaseFontSize}
   {:key :0 :mods :CTRL :action act.ResetFontSize}
   {:key :t
    :mods :LEADER
    :action (spawn-tab-right (unpack (icollect [_ bin (ipairs [:btm :htop :top])]
                                       {:args [bin] :cwd wezterm.home_dir})))}
   {:key :i
    :mods :LEADER
    :action (spawn-tab-right (unpack (icollect [_ bin (ipairs [:claude
                                                               :opencode])]
                                       {:args [bin] :cwd wezterm.home_dir})))}])

(fn macos-keys []
  (if is.macos
      [{:key "," :mods :CTRL :action (act.SendString "\027[44;5u")}
       {:key "," :mods :CTRL|SHIFT :action (act.SendString "\027[44;6u")}
       {:key :v :mods :CMD :action (act.PasteFrom :Clipboard)}
       {:key :c :mods :CMD :action (act.CopyTo :Clipboard)}]
      []))

(local single-left-down {:Down {:streak 1 :button :Left}})
(local single-left-up {:Up {:streak 1 :button :Left}})

(local double-left-down {:Down {:streak 2 :button :Left}})
(local double-left-up {:Up {:streak 2 :button :Left}})

(local triple-left-down {:Down {:streak 3 :button :Left}})
(local triple-left-up {:Up {:streak 3 :button :Left}})

(local single-left-drag {:Drag {:streak 1 :button :Left}})
(local double-left-drag {:Drag {:streak 2 :button :Left}})
(local triple-left-drag {:Drag {:streak 3 :button :Left}})

(fn mouse []
  [{:event triple-left-down
    :mods :NONE
    :action (act.SelectTextAtMouseCursor :Line)}
   {:event double-left-down
    :mods :NONE
    :action (act.SelectTextAtMouseCursor :Word)}
   {:event single-left-down
    :mods :NONE
    :action (act.SelectTextAtMouseCursor :Cell)}
   {:event single-left-down
    :mods :SHIFT
    :action (act.ExtendSelectionToMouseCursor :Cell)}
   {:event single-left-down
    :mods :ALT
    :action (act.SelectTextAtMouseCursor :Block)}
   {:event single-left-up
    :mods :SHIFT
    :action (act.CompleteSelection :ClipboardAndPrimarySelection)}
   {:event single-left-up
    :mods :NONE
    :action (act.CompleteSelection :ClipboardAndPrimarySelection)}
   {:event single-left-up
    :mods :ALT
    :action (act.CompleteSelection :ClipboardAndPrimarySelection)}
   {:event double-left-up
    :mods :NONE
    :action (act.CompleteSelection :ClipboardAndPrimarySelection)}
   {:event triple-left-up
    :mods :NONE
    :action (act.CompleteSelection :ClipboardAndPrimarySelection)}
   {:event single-left-drag
    :mods :NONE
    :action (act.ExtendSelectionToMouseCursor :Cell)}
   {:event single-left-drag
    :mods :ALT
    :action (act.ExtendSelectionToMouseCursor :Block)}
   {:event single-left-down
    :mods :ALT|SHIFT
    :action (act.ExtendSelectionToMouseCursor :Block)}
   {:event single-left-up
    :mods :ALT|SHIFT
    :action (act.CompleteSelection :ClipboardAndPrimarySelection)}
   {:event double-left-drag
    :mods :NONE
    :action (act.ExtendSelectionToMouseCursor :Word)}
   {:event triple-left-drag
    :mods :NONE
    :action (act.ExtendSelectionToMouseCursor :Line)}
   {:event {:Down {:streak 1 :button :Middle}}
    :mods :NONE
    :action (act.PasteFrom :PrimarySelection)}
   {:event single-left-up :mods :CTRL :action act.OpenLinkAtMouseCursor}
   {:event {:Down {:streak 1 :button {:WheelUp 1}}}
    :mods :NONE
    :action act.ScrollByCurrentEventWheelDelta
    :alt_screen false}
   {:event {:Down {:streak 1 :button {:WheelDown 1}}}
    :mods :NONE
    :action act.ScrollByCurrentEventWheelDelta
    :alt_screen false}])

{:disable_default_key_bindings true
 :disable_default_mouse_bindings true
 :leader {:key :a :mods :CTRL :timeout_milliseconds 1000}
 :keys (concat! (common-keys) (macos-keys))
 :mouse_bindings (mouse)}
