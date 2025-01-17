local System = tiny.processingSystem()
local keyboard_events = tiny.requireAny('key_press', 'key_release')
System.filter = tiny.requireAll(keyboard_events, 'is_event')

---@param props SystemProps
function System:initialize(props)
  self.controller_state = props.controller_state
end

function System:onAdd(e)
  if e.key_press then
    self.controller_state:push(e.keycode)
  elseif e.key_release then
    self.controller_state:release(e.keycode)
  end
end

return System
