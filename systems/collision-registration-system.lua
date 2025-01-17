local CollisionRegistrationSystem = tiny.processingSystem()
---@param e Collidable | Position
function CollisionRegistrationSystem:filter(e)
  return e.position and e.collidable and (e.collidable.radius or e.collidable.is_tile or e.collidable.is_solid)
end

---@param props SystemProps
function CollisionRegistrationSystem:initialize(props)
  self.collision_grid = props.collision_grid
end

---@param e Collidable | Position
function CollisionRegistrationSystem:onAdd(e)
  self.collision_grid:register(e)
end

---@param e Collidable | Position
function CollisionRegistrationSystem:onRemove(e)
  self.collision_grid:remove(e)
end

return CollisionRegistrationSystem
