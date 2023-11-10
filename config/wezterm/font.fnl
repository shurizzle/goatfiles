(local wezterm (require :wezterm))
(local {: is} (require :platform))
(local hostname (wezterm.hostname))

{:allow_square_glyphs_to_overflow_width :Always
 :harfbuzz_features [:ss01 :ss02 :ss03 :ss04 :ss05 :ss06 :ss07 :ss08 :zero
                     :onum :dlig :calt]
 :font (wezterm.font "Monaspace Argon")
 :font_rules [{:intensity :Normal
               :italic    true
               :font      (wezterm.font {:family "Monaspace Radon"
                                         :weight :Regular
                                         :italic true})}
              {:intensity :Half
               :italic    true
               :font      (wezterm.font {:family "Monaspace Radon"
                                         :weight :Medium
                                         :italic true})}
              {:intensity :Bold
               :italic    true
               :font      (wezterm.font {:family "Monaspace Radon"
                                         :weight :Bold
                                         :italic true})}]
 :font_size (if (= :DomPerignon hostname) 9 10)
 :warn_about_missing_glyphs false}
