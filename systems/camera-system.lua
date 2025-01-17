local CameraSystem = tiny.processingSystem()

---@param e (CameraActor | Position) | table
function CameraSystem:filter(e)
  return (e.camera_actor and e.position) or e.screen_shake or e.resize
end

local function lerp(a, b, t)
  return a + (b - a) * t
end

---@param props SystemProps
function CameraSystem:initialize(props)
  self.camera_state = props.camera_state
  self.push = require('plugins.push')
  local windowWidth, windowHeight = love.graphics.getDimensions()
  self.push:setupScreen(GAME_WIDTH, GAME_HEIGHT, windowWidth, windowHeight, {
    fullscreen = false,
    resizable = true,
  })
  self.push:resize(windowWidth, windowHeight)
  self.push:setBorderColor(PALETTE.BACKGROUND)
  self.position = vector(0, 0)
  self.offset = vector(-GAME_WIDTH / 2, -GAME_HEIGHT / 2)
  -- boundaries -- TODO: stop hardcoding
  self.left_boundary = 0
  self.top_boundary = 0
  self.right_boundary = 2000
  self.bot_boundary = 2000
  self.speed = 5
end

function CameraSystem:preWrap(dt)
  self.push:start()
end

function CameraSystem:postWrap(dt)
  self.push:finish()
end

function CameraSystem:onAdd(e)
  if e.resize and e.is_event then
    self.push:resize(e.width, e.height)
  end
end

---@param e (CameraActor| Position)
function CameraSystem:process(e, dt)
  if e.camera_actor and e.camera_actor.is_active then
    self.old_position = self.position:clone()
    self.position = e.position + self.offset
    if e.position.x >= self.right_boundary - GAME_WIDTH / 2 then
      self.position.x = self.right_boundary - GAME_WIDTH
    elseif e.position.x <= self.left_boundary + GAME_WIDTH / 2 then
      self.position.x = self.left_boundary
    end
    -- build y
    if e.position.y >= self.bot_boundary - GAME_HEIGHT / 2 then
      self.positiony = self.bot_boundary - GAME_HEIGHT
    elseif e.position.y <= self.top_boundary + GAME_HEIGHT / 2 then
      self.position.y = self.top_boundary
    end
    self.position.x = lerp(self.old_position.x, self.position.x, self.speed * dt)
    self.position.y = lerp(self.old_position.y, self.position.y, self.speed * dt)
    love.graphics.translate(-self.position.x, -self.position.y)
    self.camera_state:set_screen_rect(
      self.position.x + self.offset.x,
      self.position.y + self.offset.y,
      self.position.x + GAME_WIDTH,
      self.position.y + GAME_HEIGHT
    )
    return
  end
  if e.screen_shake then
    local shake = love.math.newTransform()
    shake:translate(love.math.random(-e.magnitude, e.magnitude), love.math.random(-e.magnitude, e.magnitude))
    love.graphics.applyTransform(shake)
    return
  end
end

return CameraSystem
