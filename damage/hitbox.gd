class_name Hitbox extends Area2D

@export var team: Globals.Teams
@export var iframe_group: String = ""
@export var iframe_duration: float = 0.2
@export var lifetime: float = -1.0

@export var hitstun: float = 0.0

@export var piercing: int = -1
var pierced: int = 0

@export var damage: float = 0.0

signal expired

func _ready() -> void:
  collision_layer = 0
  collision_mask = 4 - team * 2
  
  if iframe_group == "":
    iframe_group = str(get_instance_id())

func _process(delta: float) -> void:
  if lifetime >= 0.0:
    lifetime -= delta
    if lifetime <= 0.0:
      expire()
  
  for i in get_overlapping_areas():
    if i is Hurtbox and i.team != team:
      var did_hit: bool = (i as Hurtbox).try_hit(self)
      
      if did_hit and piercing >= 0:
        pierced += 1
        if pierced > piercing:
          expire()

func expire() -> void:
  expired.emit()
  queue_free()
