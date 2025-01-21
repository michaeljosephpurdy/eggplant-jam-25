---@class ControllableJumpableSystem
local ControllableJumpableSystem = tiny.processingSystem()
ControllableJumpableSystem.filter = tiny.requireAll('controllable', 'jumpable')

local JUMP_BUFFER = 0.05
local SMALL_JUMP = 0.30 - JUMP_BUFFER

---@param props SystemProps
function ControllableJumpableSystem:initialize(props)
  self.game_state = props.game_state
  self.controller_state = props.controller_state
end

---@param e Jumpable
function ControllableJumpableSystem:onAdd(e)
  e.jumpable.charge = 0
end

---@param e Controllable | Jumpable | DeltaPosition | Velocity
---@param dt number
function ControllableJumpableSystem:process(e, dt)
  local controls_locked = self.game_state:are_controls_locked()
  local cant_move = controls_locked or not e.controllable.is_active
  -- do nothing if the entity can't move
  if cant_move then
    return
  end
  if e.jumpable.state == 'charging' and self.controller_state:flipped_directions() then
    e.jumpable.state = 'idle'
  end
  if e.jumpable.state == 'idle' then
    e.jumpable.charge = 0
  end
  local move_forward = self.controller_state:right_down()
  local move_backward = self.controller_state:left_down()
  local charge_forward = self.controller_state:is_right_dominant()
  local charge_backward = self.controller_state:is_left_dominant()
  local is_charging = charge_forward or charge_backward
  if is_charging and e.jumpable.state == 'idle' then
    e.jumpable.state = 'charging'
  end
  if is_charging and e.jumpable.state == 'charging' then
    e.jumpable.state = 'charging'
    e.jumpable.charge = e.jumpable.charge + dt
  end
  if not is_charging and e.jumpable.state == 'charging' then
    e.jumpable.state = 'jump'
    e.jumpable.move_forward = move_forward
    e.jumpable.move_backward = move_backward
  end
  if e.jumpable.state == 'jump' then
    e.jumpable.state = 'jumping'
    if e.jumpable.charge < JUMP_BUFFER then
      e.jumpable.state = 'idle'
    elseif e.jumpable.charge < SMALL_JUMP then
      e.velocity.y = -e.jumpable.small_jump_height
    else
      e.velocity.y = -e.jumpable.large_jump_height
    end
  end
  if e.jumpable.state == 'jumping' then
    if e.jumpable.move_forward then
      e.delta_position.x = 1
    else
      e.delta_position.x = -1
    end
  end
end

return ControllableJumpableSystem
