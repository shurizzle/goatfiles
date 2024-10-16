(Status:children_add (fn []
                       (local h cx.active.current.hovered)
                       (if (or (= nil h) (not= (ya.target_family) :unix))
                           (ui.Line [])
                           (ui.Line [(: (ui.Span (or (ya.user_name h.cha.uid)
                                                     (tostring h.cha.uid)))
                                        :fg :magenta)
                                     (ui.Span ":")
                                     (: (ui.Span (or (ya.group_name h.cha.gid)
                                                     (tostring h.cha.gid)))
                                        :fg :magenta)
                                     (ui.Span " ")]))) 500
                     Status.RIGHT)

