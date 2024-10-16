local function _1_()
  local h = cx.active.current.hovered
  if ((nil == h) or (ya.target_family() ~= "unix")) then
    return ui.Line({})
  else
    return ui.Line({ui.Span((ya.user_name(h.cha.uid) or tostring(h.cha.uid))):fg("magenta"), ui.Span(":"), ui.Span((ya.group_name(h.cha.gid) or tostring(h.cha.gid))):fg("magenta"), ui.Span(" ")})
  end
end
return Status:children_add(_1_, 500, Status.RIGHT)
