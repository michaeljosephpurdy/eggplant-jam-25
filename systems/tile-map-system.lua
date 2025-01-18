local TileMapSystem = tiny.processingSystem()
TileMapSystem.filter = event_filter('load_tile_map')

---@type number[]
local SOLID_TILES = { 1 }

---@param props SystemProps
function TileMapSystem:initialize(props)
  self.level_information = props.level_information
  self.game_state = props.game_state
  self.ldtk = require('plugins.super-simple-ldtk')
  self.ldtk:init('world')
  self.ldtk:load_all()
  self.entity_factory = props.entity_factory
  self.on_image = function(image)
    ---@type Position | Drawable
    local image_data = {
      position = vector(image.x, image.y),
      drawable = { sprite = love.graphics.newImage(image.image), z_index = 0 },
    }
    if image.layer == 'Background.png' then
      image_data.drawable.z_index = -100
    end
    if image.layer == 'Normal.png' then
      image_data.drawable.z_index = -1
    end
    if image.layer == 'Foreground.png' then
      image_data.drawable.z_index = 100
    end
    self.world:add(image_data)
  end
  self.on_tile = function(tile)
    for _, solid in ipairs(SOLID_TILES) do
      if tile.value == solid then
        ---@type Position | Collidable
        local solid_tile = {
          position = vector(tile.x, tile.y),
          collidable = { is_tile = true, is_solid = true },
        } --[[@as Position | Collidable]]
        self.world:add(solid_tile)
      end
    end
  end
  self.on_entity = function(e)
    local entities = self.entity_factory:build(e)
    for _, entity in pairs(entities) do
      self.world:add(entity)
    end
  end
end

function TileMapSystem:onAdd(e)
  local level_id = e.level_id or 'Level_0'
  local loaded_level = self.ldtk:load(level_id, self.on_image, self.on_tile, self.on_entity)
  self.level_information.top_left = vector(loaded_level.x, loaded_level.y)
  self.level_information.bottom_right = vector(loaded_level.xx, loaded_level.yy)
  self.level_information.level_id = loaded_level.level_id
  self.loaded_level = level_id
end

return TileMapSystem
