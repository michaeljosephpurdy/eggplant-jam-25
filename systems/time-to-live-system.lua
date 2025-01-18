local System = tiny.processingSystem()
System.filter = tiny.requireAll('time_to_live')

---@param e ShortLived
function System:process(e, dt)
  e.time_to_live = e.time_to_live - dt
  if e.time_to_live < 0 then
    self.world:removeEntity(e)
  end
end

return System
