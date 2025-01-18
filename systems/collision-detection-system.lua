local CollisionDetectionSystem = tiny.processingSystem()

---@param props SystemProps
function CollisionDetectionSystem:initialize(props)
  self.collision_grid = props.collision_grid
end

---@param e FuturePosition | Position | Collidable | Velocity
function CollisionDetectionSystem:filter(e)
  return e.position and e.collidable and e.collidable.detection and e.future_position and e.velocity
end

---@param e FuturePosition | Position | Collidable | Velocity
function CollisionDetectionSystem:process(e, _)
  e.collidable.on_ground = false
  -- first, we'll check horizontal collisions
  ---@type (Position | Collidable)[]
  local horizontal_collisions = self.collision_grid:single_query(e.future_position.x, e.position.y)
  local horizontal_solid_vector = nil
  for _, other in pairs(horizontal_collisions) do
    if other.collidable.is_tile and other.collidable.is_solid then
      horizontal_solid_vector = other.position - e.position
      break
    end
  end
  -- second, we'll check vertical collisions
  ---@type (Position | Collidable)[]
  local vertical_collisions = self.collision_grid:single_query(e.position.x, e.future_position.y)
  local vertical_solid_vector = nil
  for _, other in pairs(vertical_collisions) do
    if other.collidable.is_tile and other.collidable.is_solid then
      vertical_solid_vector = other.position - e.position
      break
    end
  end
  -- third, we'll check all surrounding collisions
  ---@type (Position | Collidable)[]
  local collisions = self.collision_grid:query(e.future_position.x, e.future_position.y)
  for _, other in pairs(collisions) do
    if other.collidable.is_solid or other.collidable.is_tile then
      goto continue
    end
    local max_distance = e.collidable.radius + other.collidable.radius
    -- TODO: can't this use dot product or something of the vectors?
    local distance_squared = ((other.position.x - e.future_position.x) * (other.position.x - e.future_position.x))
      + ((other.position.y - e.future_position.y) * (other.position.y - e.future_position.y))
    local overlaps = distance_squared <= max_distance * max_distance

    if overlaps then
      if e == other then
        --do nothing for self-collisions
        goto continue
      end
      ---@cast e +Player
      ---@cast other +Trigger
      if e.player and other.trigger then
        other.trigger.triggered = true
        goto continue
      end
      ---@cast other -Trigger
      ---@cast other +LinkedLevel
      if other.linked_level_id then
        tiny_world:addEntity({
          screen_transition_event = {
            transition_time = 1,
            fade_out = true,
            level_to_load = other.linked_level_id,
          },
        }--[[@as ScreenTransitionEvent]])
        goto continue
      end
      ---@cast other -LinkedLevel
    end
    ::continue::
  end
  if horizontal_solid_vector then
    e.future_position.x = e.position.x
    e.velocity.x = 0
  end
  if vertical_solid_vector then
    e.future_position.y = e.position.y
    e.velocity.y = 0
    e.collidable.on_ground = vertical_solid_vector.y > 0
  end
end

return CollisionDetectionSystem
