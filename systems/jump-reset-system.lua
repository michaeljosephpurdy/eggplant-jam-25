local JumpResetSystem = tiny.processingSystem()
JumpResetSystem.filter = tiny.requireAll('collidable', 'velocity', 'jumpable')

---@param e Jumpable | Velocity | Collidable
function JumpResetSystem:process(e, dt)
  if e.collidable.on_ground and e.jumpable.did_single_jump and e.velocity.y == 0 then
    e.jumpable.did_single_jump = false
  end
end

return JumpResetSystem
