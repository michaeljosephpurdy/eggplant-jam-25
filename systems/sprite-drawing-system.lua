local SpriteDrawingSystem = tiny.sortedProcessingSystem()
SpriteDrawingSystem.filter = tiny.requireAll('position', 'drawable')

function SpriteDrawingSystem:initialize()
  self.ordered_sprites = {}
  self.default_offset = vector(0, 0)
end

---@param e1 Drawable
---@param e2 Drawable
function SpriteDrawingSystem:compare(e1, e2)
  return (e1.drawable.z_index or 0) < (e2.drawable.z_index or 0)
end

---@param sprite Position | Drawable
function SpriteDrawingSystem:process(sprite, dt)
  if sprite.drawable.hidden then
    return
  end
  local x, y = sprite.position.x, sprite.position.y
  local offset = sprite.drawable.sprite_offset or self.default_offset
  local origin_offset = sprite.drawable.origin_offset or 0
  local rotation = sprite.position.rotation or 0
  local scale = sprite.drawable.scale or 1
  love.graphics.draw(
    sprite.drawable.sprite,
    x + offset.x,
    y + offset.y,
    rotation,
    scale,
    scale,
    origin_offset,
    origin_offset
  )
end

return SpriteDrawingSystem
