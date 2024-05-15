(local wezterm (require :wezterm))
(local act wezterm.action)
(local {: is} (require :platform))

(local cpmods (if is.macos :CMD :CTRL|SHIFT))

(fn common-keys []
  [{:key :q :mods :LEADER :action (act.CloseCurrentPane {:confirm true})}
   {:key :c :mods :LEADER :action (act.SpawnTab :CurrentPaneDomain)}
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
   {:key :a :mods :LEADER|CTRL :action (act.SendString "\001")}
   {:key ":" :mods :SHIFT|LEADER :action act.ShowDebugOverlay}
   {:key :v :mods :LEADER :action act.ActivateCopyMode}
   {:key "/" :mods :LEADER :action (act.Search {:CaseInSensitiveString ""})}
   {:key ":" :mods :LEADER :action act.ShowDebugOverlay}
   {:key :v :mods cpmods :action (act.PasteFrom :Clipboard)}
   {:key :c :mods cpmods :action (act.CopyTo :Clipboard)}
   {:key "<" :mods :LEADER :action (act.MoveTabRelative -1)}
   {:key ">" :mods :LEADER :action (act.MoveTabRelative 1)}
   {:key "<" :mods :LEADER|SHIFT :action (act.MoveTabRelative -1)}
   {:key ">" :mods :LEADER|SHIFT :action (act.MoveTabRelative 1)}])

(fn macos-keys []
  (if is.macos
      [{:key "," :mods :CTRL :action (act.SendString "\027[44;5u")}
       {:key "," :mods :CTRL|SHIFT :action (act.SendString "\027[44;6u")}]
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

