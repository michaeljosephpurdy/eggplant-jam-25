---@class EntityFactory
local EntityFactory = class('EntityFactory') --[[@as EntityFactory]]
---@enum EntityTypes
local EntityTypes = {
  PLAYER = 'PLAYER',
  PLAYER_SPAWN = 'PLAYER_SPAWN',
  LEVEL_EXIT = 'LEVEL_EXIT',
}
EntityFactory.types = EntityTypes

---@private
---@type { [EntityTypes]: table }
EntityFactory.entities = {
  [EntityTypes.PLAYER_SPAWN] = {
    player_spawn = true,
  } --[[@as PlayerSpawn]],
  [EntityTypes.LEVEL_EXIT] = {
    is_level_exit = true,
    drawable = { sprite = love.graphics.newImage('assets/exit.png') },
    collidable = { radius = 16 },
  } --[[@as Drawable | Collidable ]],
  [EntityTypes.PLAYER] = {
    camera_actor = { is_active = true },
    controllable = { is_active = true },
    is_character = true,
    drawable = { sprite = love.graphics.newImage('assets/dog-idle.png'), sprite_offset = vector(-8, -16) },
    player = { is_active = true },
    collidable = { detection = true, radius = 10 },
    movable = {
      is_moving = false,
      speed = 0,
      max_speed = 85,
      acceleration = 2,
      move_forward = false,
      move_backward = false,
    },
    jumpable = { can_jump = true, jump_height = 300 },
    velocity = vector(0, 0),
    delta_position = vector(0, 0),
    future_position = vector(0, 0),
    position = vector(0, 0),
    gravity = { enabled = true, on_ground = false },
  } --[[@as Gravity | FuturePosition | DeltaPosition | Velocity | Collidable | Jumpable | CameraActor | Controllable | Movable | Drawable | Player]],
}

---@param e { customFields?: table, id: string, type?: string, x: number, y: number }
---@return table
function EntityFactory:build(e)
  -- We're gonna do some weird overwriting of entity type here
  -- this is because during jam there was singular Entity object
  -- with inner entity type field
  -- Post-jam version though has different Entity object, which is
  -- helpful in LDtk because then fields (like 'path') can be on
  -- some entities and not all
  local entity = self:build_single({
    position = vector(e.x, e.y),
    type = e.id --[[@as EntityTypes]],
  })
  if entity.is_level_exit then
    (entity --[[@as LinkedLevel]]).linked_level_id = e.customFields.entrance.levelIid
  end
  return { entity }
end

---@private
---@param e { type: EntityTypes }
---@return table
function EntityFactory:build_single(e)
  if not self.entities[e.type] then
    print('NO ENTITY FOUND FOR TYPE: ' .. (e.type or 'UNKNOWN'))
    return {}
  end
  local new_entity = {}
  for k, v in pairs(self.entities[e.type]) do
    new_entity[k] = v
  end
  for k, v in pairs(e) do
    new_entity[k] = v
  end
  new_entity.type = e.type
  new_entity.draw_debug = true
  return new_entity
end

return EntityFactory
