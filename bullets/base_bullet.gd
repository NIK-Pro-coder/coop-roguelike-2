extends CharacterBody2D
class_name Bullet

@export var SPEED: float = 900.0

func _process(delta: float) -> void:
  velocity = Vector2.from_angle(rotation) * SPEED * delta * 60
  
  move_and_slide()
