local PlayerSpawningSystem = tiny.processingSystem()
PlayerSpawningSystem.filter = tiny.requireAll('player_spawn', 'position')

---@param props SystemProps
function PlayerSpawningSystem:initialize(props)
  self.entity_factory = props.entity_factory
end

---@param e PlayerSpawn | Position
function PlayerSpawningSystem:onAdd(e)
  if not self.player then
    self.player = self.entity_factory:build({
      id = 'PLAYER',
      x = e.position.x,
      y = e.position.y,
    })[1]
  end
  self.player.position = e.position:clone()
  self.player.future_position = self.player.position:clone()
  self.world:addEntity(self.player)
end

return PlayerSpawningSystem
