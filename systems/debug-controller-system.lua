local DebugOverlaySystem = tiny.system()

---@param props SystemProps
function DebugOverlaySystem:initialize(props)
  self.controller_state = props.controller_state
end

function DebugOverlaySystem:update(dt)
  love.graphics.push()
  love.graphics.origin()
  if self.controller_state:left_down() then
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.rectangle('fill', 0, 0, GAME_WIDTH / 2, GAME_HEIGHT / 4)
  end
  if self.controller_state:right_down() then
    love.graphics.setColor(0, 0, 1, 1)
    love.graphics.rectangle('fill', GAME_WIDTH / 2, 0, GAME_WIDTH / 2, GAME_HEIGHT / 4)
  end
  love.graphics.pop()
end

return DebugOverlaySystem
