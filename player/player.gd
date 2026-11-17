extends CharacterBody2D
class_name Player

const SPEED: float = 600.0
const ACCEL: float = 100.0

@export var DEVICE_ID: int = 0

func get_movement_dir() -> Vector2:
  return InputMngr.get_vector(
    "move_left", "move_right",
    "move_up", "move_down",
    DEVICE_ID
  )

func _process(delta: float) -> void:
  velocity = velocity.move_toward(
    get_movement_dir() * SPEED * delta * 60,
    ACCEL * delta * 60
  )
  
  move_and_slide()
