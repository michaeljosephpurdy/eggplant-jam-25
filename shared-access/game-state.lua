---@class GameState
local GameState = class('GameState') ---[[@as GameState]]

function GameState:initialize()
  self.game_started = false

  self.seconds = 0
  self.minutes = 0
  self.hours = 9
  self.real_seconds_to_game_seconds = 1
end

function GameState:toggle_controls()
  self.controls_locked = not self.controls_locked
end

function GameState:are_controls_locked()
  return self.controls_locked
end

function GameState:progress_time(dt)
  self.seconds = self.seconds + (dt * self.real_seconds_to_game_seconds)
  if self.seconds >= 60 then
    self.minutes = self.minutes + 15
    self.seconds = 0
  end
  if self.minutes >= 60 then
    self.hours = self.hours + 1
    self.minutes = 0
  end
  if self.hours >= 24 then
    self.days = self.days + 1
    self.hours = 0
  end
end

return GameState
