local ControllerUpdateSystem = tiny.system()

---@param props SystemProps
function ControllerUpdateSystem:initialize(props)
  self.controller_state = props.controller_state
end

function ControllerUpdateSystem:update(dt)
  self.controller_state:update()
end

return ControllerUpdateSystem
