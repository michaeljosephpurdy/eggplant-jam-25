---@class ControllableToMovableAndJumpableSystem
local ControllableToMovableAndJumpableSystem = tiny.processingSystem()
ControllableToMovableAndJumpableSystem.filter = tiny.requireAll('controllable', 'movable', 'jumpable')

---@param props SystemProps
function ControllableToMovableAndJumpableSystem:initialize(props)
  self.game_state = props.game_state
  self.controller_state = props.controller_state
end

---@param e Controllable | Movable | Jumpable
function ControllableToMovableAndJumpableSystem:process(e, _)
  local controls_locked = self.game_state:are_controls_locked()
  local can_move = not controls_locked and e.controllable.is_active
  e.movable.move_forward = can_move
    and self.controller_state.right >= 1
    and self.controller_state.right > self.controller_state.left
  e.movable.move_backward = can_move
    and self.controller_state.left >= 1
    and self.controller_state.left > self.controller_state.right
  e.movable.is_moving = e.movable.move_forward or e.movable.move_backward

  local jump_forward = e.movable.move_forward and self.controller_state.left > 0
  local jump_backward = e.movable.move_backward and self.controller_state.right > 0
  local can_jump = e.jumpable.can_jump and not e.jumpable.did_single_jump
  if can_jump and (jump_forward or jump_backward) then
    e.jumpable.perform_single_jump = true
  end
end

return ControllableToMovableAndJumpableSystem
