---@class ControllerState
local ControllerState = class('ControllerState') --[[@as ControllerState]]
ControllerState.static.is_singleton = true

function ControllerState:initialize()
  self.left = 0
  self.right = 0
  self.changed = false
  ---@private
  self.right_dominant = false
  ---@private
  self.was_right_dominant = false
  ---@private
  self.left_dominant = false
  ---@private
  self.was_left_dominant = false
end

function ControllerState:update()
  self.was_right_dominant = self.right_dominant
  self.was_left_dominant = self.left_dominant
  if
    love.keyboard.isDown('f1')
    or love.keyboard.isDown('f2')
    or love.keyboard.isDown('f3')
    or love.keyboard.isDown('f4')
    or love.keyboard.isDown('f5')
    or love.keyboard.isDown('tab')
    or love.keyboard.isDown('capslock')
    or love.keyboard.isDown('lshift')
    or love.keyboard.isDown('lctrl')
    or love.keyboard.isDown('lalt')
    or love.keyboard.isDown('lgui')
    or love.keyboard.isDown('`')
    or love.keyboard.isDown('1')
    or love.keyboard.isDown('2')
    or love.keyboard.isDown('3')
    or love.keyboard.isDown('4')
    or love.keyboard.isDown('5')
    or love.keyboard.isDown('q')
    or love.keyboard.isDown('w')
    or love.keyboard.isDown('e')
    or love.keyboard.isDown('r')
    or love.keyboard.isDown('t')
    or love.keyboard.isDown('a')
    or love.keyboard.isDown('s')
    or love.keyboard.isDown('d')
    or love.keyboard.isDown('f')
    or love.keyboard.isDown('g')
    or love.keyboard.isDown('z')
    or love.keyboard.isDown('x')
    or love.keyboard.isDown('c')
    or love.keyboard.isDown('v')
    or love.keyboard.isDown('b')
    or love.keyboard.isDown('left')
    or love.keyboard.isDown('down')
  then
    self.left = self.left + 1
  else
    self.left = 0
  end
  if
    love.keyboard.isDown('f6')
    or love.keyboard.isDown('f7')
    or love.keyboard.isDown('f8')
    or love.keyboard.isDown('f9')
    or love.keyboard.isDown('f10')
    or love.keyboard.isDown('f11')
    or love.keyboard.isDown('f12')
    or love.keyboard.isDown('6')
    or love.keyboard.isDown('7')
    or love.keyboard.isDown('8')
    or love.keyboard.isDown('9')
    or love.keyboard.isDown('0')
    or love.keyboard.isDown('-')
    or love.keyboard.isDown('=')
    or love.keyboard.isDown('backspace')
    or love.keyboard.isDown('y')
    or love.keyboard.isDown('u')
    or love.keyboard.isDown('i')
    or love.keyboard.isDown('o')
    or love.keyboard.isDown('p')
    or love.keyboard.isDown('[')
    or love.keyboard.isDown(']')
    or love.keyboard.isDown('\\')
    or love.keyboard.isDown('h')
    or love.keyboard.isDown('j')
    or love.keyboard.isDown('k')
    or love.keyboard.isDown('l')
    or love.keyboard.isDown(';')
    or love.keyboard.isDown("'")
    or love.keyboard.isDown('return')
    or love.keyboard.isDown('b')
    or love.keyboard.isDown('n')
    or love.keyboard.isDown('m')
    or love.keyboard.isDown(',')
    or love.keyboard.isDown('.')
    or love.keyboard.isDown('/')
    or love.keyboard.isDown('rshift')
    or love.keyboard.isDown('ralt')
    or love.keyboard.isDown('rctrl')
    or love.keyboard.isDown('rgui')
    or love.keyboard.isDown('right')
    or love.keyboard.isDown('up')
  then
    self.right = self.right + 1
  else
    self.right = 0
  end
  self.right_dominant = self:is_right_dominant()
  self.left_dominant = self:is_left_dominant()
end

function ControllerState:right_down()
  return self.right > 0
end

function ControllerState:left_down()
  return self.left > 0
end

function ControllerState:is_right_dominant()
  return self.left > 0 and self.right > self.left
end

function ControllerState:is_left_dominant()
  return self.right > 0 and self.left > self.right
end

function ControllerState:flipped_directions()
  return (self.was_right_dominant and self.right == 0) or (self.was_left_dominant and self.left == 0)
end

return ControllerState
