(local wezterm (require :wezterm))
(local {: is} (require :platform))

{:allow_square_glyphs_to_overflow_width :Always
 :harfbuzz_features [:ss01 :ss02 :ss03 :ss04 :ss05 :ss06 :zero :onum]
 :font (wezterm.font_with_fallback ["CommitMono"
                                    "Hack Nerd Font Mono"
                                    "JetBrains Mono"
                                    "Noto Color Emoji"
                                    "Symbols Nerd Font Mono"])
 :font_size (if (or is.lin is.win) 10 11)
 :warn_about_missing_glyphs false}
