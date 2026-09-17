class_name Hurtbox extends Area2D

@export var team: Globals.Teams

@export var max_hp: float = 0.0
var hp: float = 0

var iframes: Dictionary[String, float] = {}

func _ready() -> void:
  hp = max_hp
  
  collision_mask = 0
  collision_layer = 2 + team * 2
  
func _process(delta: float) -> void:
  for i in iframes.keys():
    iframes[i] -= delta
    if iframes[i] <= 0.0:
      iframes.erase(i)

signal hit(dmg: float, hitstun: float)
signal died

func try_hit(from: Hitbox) -> bool:
  if from.iframe_group in iframes:
    return false
  
  hp -= from.damage
  hp = clamp(hp, 0, max_hp)
  
  hit.emit(from.damage, from.hitstun)
  if hp <= 0.0:
    died.emit()
  
  iframes[from.iframe_group] = from.iframe_duration
  
  return true
