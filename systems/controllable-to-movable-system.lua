---@class ControllableToMovableSystem
local ControllableToMovableSystem = tiny.processingSystem()
ControllableToMovableSystem.filter = tiny.requireAll('controllable', 'movable', 'jumpable')

---@param props SystemProps
function ControllableToMovableSystem:initialize(props)
  self.game_state = props.game_state
  self.controller_state = props.controller_state
end

---@param e Controllable | Movable | Jumpable
---@param dt number
function ControllableToMovableSystem:process(e, dt)
  local controls_locked = self.game_state:are_controls_locked()
  local can_move = not controls_locked and e.controllable.is_active
  e.movable.move_forward = can_move
    and self.controller_state.right >= 1
    and self.controller_state.right > self.controller_state.left
  e.movable.move_backward = can_move
    and self.controller_state.left >= 1
    and self.controller_state.left > self.controller_state.right
  e.movable.is_moving = e.movable.move_forward or e.movable.move_backward
end

return ControllableToMovableSystem
