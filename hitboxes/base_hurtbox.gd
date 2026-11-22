extends Area2D
class_name Hurtbox

enum HurtboxTeams {
  Player = 4,
  Enemy  = 2,
}

@export var team: HurtboxTeams = HurtboxTeams.Player
var active: bool = true

var color: Color

func _ready() -> void:
  collision_mask = 0
  collision_layer = team
  
  color = Color(0, 1, 0, .2) if team == HurtboxTeams.Player else Color(1, 0, 0, .2)

var iframes: Dictionary[String, float] = {}

func _process(delta: float) -> void:
  for i in iframes.keys():
    iframes[i] -= delta
    if iframes[i] <= 0:
      iframes.erase(i)

  for i in get_children():
    if i is CollisionShape2D:
      i.debug_color = color if active else Color(1.0, 1.0, 1.0, 0.2)

func attempt_hit(hitbox: Hitbox) -> Node:
  if !active: return null
  
  if hitbox.local_name in iframes:
    return null
  
  iframes[hitbox.local_name] = hitbox.local_duration
  
  return get_parent()
