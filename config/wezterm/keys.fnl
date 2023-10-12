(local wezterm (require :wezterm))
(local {: is} (require :platform))

(local cpmods (if is.macos :CMD :CTRL|SHIFT))

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
  (if is.macos
      [{:key    ","
        :mods   :CTRL
        :action (wezterm.action.SendString "\27[44;5u")}
       {:key    ","
        :mods   :CTRL|SHIFT
        :action (wezterm.action.SendString "\27[44;6u")}]
      []))

{:disable_default_key_bindings true
 :leader {:key :a :mods :CTRL :timeout_milliseconds 1000}
 :keys   (concat! (common-keys) (macos-keys))
 :mouse_bindings [{:event {:Up {:streak 1 :button :Left}}
                   :mods :CTRL
                   :action wezterm.action.OpenLinkAtMouseCursor}]}
