;; Show user:group of the hovered file in the status bar
(Status:children_add (fn []
                       (local h cx.active.current.hovered)
                       (if (or (= nil h) (not= (ya.target_family) :unix))
                           ""
                           (ui.Line [(: (ui.Span (or (ya.user_name h.cha.uid)
                                                     (tostring h.cha.uid)))
                                        :fg :magenta)
                                     ":"
                                     (: (ui.Span (or (ya.group_name h.cha.gid)
                                                     (tostring h.cha.gid)))
                                        :fg :magenta)
                                     " "]))) 500
                     Status.RIGHT)
