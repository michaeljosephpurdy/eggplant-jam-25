---@meta

---@class CameraActor
---@field camera_actor _CameraActor
---@class _CameraActor
---@field is_active boolean

---@class Gravity
---@field gravity _Gravity
---@class _Gravity
---@field enabled boolean
---@field on_ground boolean

---@class Position
---@field position Vector.lua
---@class FuturePosition
---@field future_position Vector.lua
---@class DeltaPosition
---@field delta_position Vector.lua
---@class Velocity
---@field velocity Vector.lua

---@class Collidable
---@field collidable _Collidable
---@class _Collidable
---@field radius? number
---@field is_solid? boolean
---@field is_tile? boolean
---@field detection? boolean
---@field on_ground? boolean

---@class LinkedLevel
---@field linked_level_id string

---@class Controllable
---@field controllable _Controllable
---@class _Controllable
---@field is_active boolean

---@class Jumpable
---@field jumpable _Jumpable
---@class _Jumpable
---@field jump_height? number
---@field can_jump? boolean
---@field perform_single_jump? boolean
---@field did_single_jump? boolean

---@class Movable
---@field movable _Movable
---@class _Movable
---@field is_moving boolean
---@field move_forward boolean
---@field move_backward boolean
---@field speed number
---@field acceleration number
---@field max_speed number
---@field current_max_speed? number
---@field friction? number

---@class Drawable
---@field drawable _Drawable
---@class _Drawable
---@field z_index? number
---@field sprite love.Image
---@field scale? number
---@field sprite_offset? Vector.lua
---@field origin_offset? number

---@class PlayerSpawn
---@field player_spawn boolean

---@class Player
---@field player _Player
---@class _Player
---@field is_active boolean

---@class Trigger
---@field trigger _Trigger
---@class _Trigger
---@field triggered? boolean

---@class Event
---@field event _Event
---@class _Event
---@field load_tile_map? boolean
---@field ldtk_level_name? string
---@field key_press? boolean
---@field keycode? string

---@class Text
---@field text string

---@class ShortLived
---@field time_to_live number

---@class ScreenTransitionEvent
---@field screen_transition_event _ScreenTransitionEvent
---@class _ScreenTransitionEvent
---@field transition_time number
---@field progress? number
---@field fade_in? boolean
---@field fade_out? boolean
---@field level_to_load? string
