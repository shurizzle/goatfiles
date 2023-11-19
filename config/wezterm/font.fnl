(local wezterm (require :wezterm))
(local {: is} (require :platform))
(local hostname (wezterm.hostname))

(local harfbuzz_features [:ss01 :ss02=0 :ss03 :ss04 :ss05 :ss06 :ss07 :ss08
                          :calt :dlig:])

{:allow_square_glyphs_to_overflow_width :Always
 :harfbuzz_features [:ss01 :ss02 :ss03 :ss04 :ss05 :ss06 :ss07 :ss08 :zero
                     :onum :dlig :calt]
 :font (wezterm.font {:family "Monaspace Argon"
                      : harfbuzz_features})
 :font_rules [{:intensity :Normal
               :italic    true
               :font      (wezterm.font {:family "Monaspace Radon"
                                         :weight :Regular
                                         :italic false
                                         : harfbuzz_features})}
              {:intensity :Half
               :italic    true
               :font      (wezterm.font {:family "Monaspace Radon"
                                         :weight :Medium
                                         :italic false
                                         : harfbuzz_features})}
              {:intensity :Bold
               :italic    true
               :font      (wezterm.font {:family "Monaspace Radon"
                                         :weight :Bold
                                         :italic false
                                         : harfbuzz_features})}]
 :font_size (if (= :DomPerignon hostname) 9 10)
 :warn_about_missing_glyphs false}
