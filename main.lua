function love.load()
  math.randomseed(os.time())

  json = require('plugins.json')
  tiny = require('plugins.tiny-ecs')
  class = require('plugins.middleclass')
  ldtk = require('plugins.super-simple-ldtk')
  vector = require('plugins.vector')

  GAME_WIDTH = 384
  GAME_HEIGHT = 216
  GAME_SCALE = 1
  JUMP_HEIGHT = 400
  NEW_LINE = string.char(10)
  TILE_SIZE = 16

  SYSTEMS_IN_ORDER = {
    require('systems.audio-system'),
    require('systems.collision-registration-system'),
    require('systems.keyboard-state-system'),
    require('systems.controller-update-system'),
    require('systems.tile-map-system'),
    require('systems.path-following-system'),
    require('systems.controllable-to-movable-and-jumpable-system'),
    require('systems.movable-to-delta-position-system'),
    require('systems.jumpable-to-delta-position-system'),
    require('systems.movable-to-velocity-system'),
    require('systems.jumpable-to-velocity-system'),
    require('systems.gravity-application-system'),
    require('systems.entity-movement-system'),
    require('systems.sprite-animating-system'),
    require('systems.trigger-resetting-system'),
    require('systems.collision-detection-system'),
    require('systems.collision-update-system'),
    require('systems.jump-reset-system'),
    require('systems.repel-system'),
    require('systems.camera-system'),
    require('systems.sprite-drawing-system'),
    require('systems.text-display-system'),
    require('systems.dialogue-system'),
    require('systems.entity-cleanup-system'),
    require('systems.time-to-live-system'),
    require('systems.delayed-function-execution-system'),
    require('systems.debug-overlay-system'),
  }

  PALETTE = {
    BACKGROUND = { love.math.colorFromBytes(88, 245, 177) },
  }

  local windowWidth, windowHeight = love.window.getDesktopDimensions()
  love.graphics.setDefaultFilter('nearest', 'nearest')

  logger = require('logger')()

  KeyPressEvent = require('entities.events.key-press')
  KeyReleaseEvent = require('entities.events.key-release')
  ScreenResizeEvent = require('entities.events.screen-resize')

  local joystick_state = require('shared-access.joystick')() --[[@as JoystickState]]
  local keyboard_state = require('shared-access.keyboard')() --[[@as KeyboardState]]
  local controller_state = require('shared-access.controller')() --[[@as ControllerState]]
  local entity_factory = require('shared-access.entity-factory')() --[[@as EntityFactory]]
  local game_state = require('shared-access.game-state')() --[[@as GameState]]
  local camera_state = require('shared-access.camera-state')() --[[@as CameraState]]
  local collision_grid = require('plugins.collision-grid').new(
    16,
    1000,
    1000,
    ---@param e Position
    function(e)
      return e.position.x, e.position.y
    end
  )

  love.graphics.setLineStyle('rough')
  love.window.setMode(GAME_WIDTH, GAME_HEIGHT)
  tiny_world = tiny.world()

  ---@class SystemProps
  local system_props = {
    joystick_state = joystick_state,
    keyboard_state = keyboard_state,
    entity_factory = entity_factory,
    collision_grid = collision_grid,
    game_state = game_state,
    camera_state = camera_state,
    controller_state = controller_state,
  }
  for i, system in ipairs(SYSTEMS_IN_ORDER) do
    print('loading #' .. tostring(i) .. ' system: ' .. tostring(system))
    assert(system, tostring(i) .. ' # system not found')
    if system.initialize then
      system:initialize(system_props)
    end
    tiny_world:addSystem(system)
  end
  ---@param e Event
  tiny_world.addEvent = function(self, e)
    self:addEntity(e)
  end
  tiny_world:addEvent({
    event = {
      load_tile_map = true,
    },
  })
end

function love.update(dt)
  delta_time = dt
end

function love.draw()
  tiny_world:update(delta_time)
end

function love.keypressed(k)
  tiny_world:addEntity(KeyPressEvent(k))
end

function love.keyreleased(k)
  tiny_world:addEntity(KeyReleaseEvent(k))
end

function love.resize(w, h)
  tiny_world:addEntity(ScreenResizeEvent(w, h))
end

function event_filter(field)
  return function(system, e)
    return e.event and e.event[field]
  end
end

function PRINT_TABLE(tbl, depth)
  depth = depth or 0
  local tab = string.rep(' ', depth)
  for k, v in pairs(tbl) do
    print(tab .. k)
    if type(v) == 'table' then
      PRINT_TABLE(v, depth + 1)
    else
      print(tab .. tostring(v))
    end
  end
end

---@param min number The minimum value.
---@param val number The value to clamp.
---@param max number The maximum value.
function math.clamp(min, val, max)
  return math.max(min, math.min(val, max))
end
