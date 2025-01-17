local FrictionSystem = tiny.processingSystem()

---@param e Velocity | Movable | Collidable
function FrictionSystem:filter(e)
  return e.velocity and e.movable and not (e.collidable or e.collidable.is_solid)
end

---@param e Velocity | Movable
function FrictionSystem:process(e, dt)
  local friction = e.movable.friction or 0.009
  local friction_vector = vector(friction, 1)
  --e.velocity = e.velocity * friction_vector
end

return FrictionSystem
