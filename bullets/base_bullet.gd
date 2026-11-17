extends CharacterBody2D
class_name BaseBullet

@export var speed: float
@export var damage: int

func _process(delta: float) -> void:
  velocity = Vector2.from_angle(rotation) * speed * delta * 60
  
  move_and_slide()
