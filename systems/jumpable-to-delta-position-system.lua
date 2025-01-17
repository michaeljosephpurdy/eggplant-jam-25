local JumpableToDeltaPositionSystem = tiny.processingSystem()
JumpableToDeltaPositionSystem.filter = tiny.requireAll('jumpable', 'delta_position')

return JumpableToDeltaPositionSystem
