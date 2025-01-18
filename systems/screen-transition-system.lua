local ScreenTransitionSystem = tiny.processingSystem()
ScreenTransitionSystem.filter = tiny.requireAll('screen_transition_event')

---@param e ScreenTransitionEvent
function ScreenTransitionSystem:onAdd(e)
  e.screen_transition_event.progress = 0
end

---@param e ScreenTransitionEvent
function ScreenTransitionSystem:process(e, dt)
  e.screen_transition_event.progress = e.screen_transition_event.progress + dt
  local alpha = e.screen_transition_event.progress / e.screen_transition_event.transition_time
  if e.screen_transition_event.fade_in then
    alpha = 1 - alpha
  end
  self.world:addEntity({ time_to_live = 0, position = vector(100, 100), text = 'alpha: ' .. tostring(alpha) }--[[@as Position | Text | ShortLived]])
  love.graphics.pop()
  love.graphics.setColor(0, 0, 0, alpha)
  love.graphics.rectangle('fill', 0, 0, GAME_WIDTH * GAME_SCALE, GAME_HEIGHT * GAME_SCALE, 0)
  love.graphics.push()
  -- remove entity
  if e.screen_transition_event.progress > e.screen_transition_event.transition_time then
    self.world:removeEntity(e)
    if e.screen_transition_event.fade_out then
      if e.screen_transition_event.level_to_load then
        self.world:clearEntities()
        self.world:addEntity({
          event = {
            load_tile_map = true,
          },
          level_id = e.screen_transition_event.level_to_load,
        })
      end
    end
  end
end

---@param e ScreenTransitionEvent
function ScreenTransitionSystem:onRemove(e)
  if not e.screen_transition_event.fade_out then
    return
  end
  ---@type ScreenTransitionEvent
  local fade_in_event = {
    screen_transition_event = {
      transition_time = e.screen_transition_event.transition_time,
      fade_in = true,
    },
  }
  self.world:addEntity(fade_in_event)
end

return ScreenTransitionSystem
