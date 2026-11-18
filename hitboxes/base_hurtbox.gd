extends Area2D
class_name Hurtbox

enum HurtboxTeams {
  Player = 4,
  Enemy  = 2,
}

@export var team: HurtboxTeams = HurtboxTeams.Player

func _ready() -> void:
  collision_mask = 0
  collision_layer = team

var iframes: Dictionary[String, float] = {}

func _process(delta: float) -> void:
  for i in iframes.keys():
    iframes[i] -= delta
    if iframes[i] <= 0:
      iframes.erase(i)

func attempt_hit(hitbox: Hitbox) -> Node:
  if hitbox.local_name in iframes:
    return null
  
  iframes[hitbox.local_name] = hitbox.local_duration
  
  return get_parent()
