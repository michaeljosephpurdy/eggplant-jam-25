local JumpableToVelocitySystem = tiny.processingSystem()
JumpableToVelocitySystem.filter = tiny.requireAll('jumpable', 'velocity')

function JumpableToVelocitySystem:process(e, dt)
  if e.jumpable.perform_single_jump then
    e.jumpable.perform_single_jump = false
    if e.collidable.on_ground then
      e.jumpable.did_single_jump = true
      e.velocity.y = -e.jumpable.jump_height
    end
  end
end

return JumpableToVelocitySystem
