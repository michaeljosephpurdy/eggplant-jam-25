local CollisionUpdateSystem = tiny.processingSystem()
local rejection_filter = tiny.rejectAny('is_solid', 'is_tile')
CollisionUpdateSystem.filter = tiny.requireAll('future_position', 'position', rejection_filter)

function CollisionUpdateSystem:initialize(props)
  self.collision_grid = props.collision_grid --[[@as CollisionGrid]]
end

---@param e FuturePosition | Position
function CollisionUpdateSystem:process(e, dt)
  self.collision_grid:update(e, e.future_position.x, e.future_position.y)
  e.position = e.future_position:clone()
end

return CollisionUpdateSystem
