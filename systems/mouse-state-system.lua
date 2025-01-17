local MouseStateSystem = tiny.processingSystem()
MouseStateSystem.filter = tiny.requireAll()

---@param props SystemProps
function MouseStateSystem:initialize(props)
  self.mouse_state = props.mouse_state
end

function MouseStateSystem:update(dt)
  self.mouse_state:update()
end

return MouseStateSystem
