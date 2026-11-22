extends Area2D
class_name Hitbox

enum HitboxTeams {
  Player = 2,
  Enemy  = 4,
}

@export var team: HitboxTeams = HitboxTeams.Player
@export var local_name: String = ""
@export var local_duration: float = 0.0
@export var hit_inactive: bool = false

var active: bool = true
var color: Color

func _ready() -> void:
  collision_layer = 0
  collision_mask = team
  
  if local_name == "":
    local_name = str(get_instance_id())
    
  color = Color(0, 1, 0, .2) if team == HitboxTeams.Player else Color(1, 0, 0, .2)

func _process(_delta: float) -> void:
  for i in get_overlapping_areas():
    hurtbox_entered(i)

  for i in get_children():
    if i is CollisionShape2D:
      i.debug_color = color if active else Color(1.0, 1.0, 1.0, 0.2)

signal hit_node(node: Node)

func hurtbox_entered(hurtbox: Hurtbox) -> void:
  var parent := hurtbox.attempt_hit(self)
  
  if !parent:
    return

  hit_node.emit(parent)
