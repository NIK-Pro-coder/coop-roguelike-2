extends CharacterBody2D
class_name Player

const SPEED: float = 600.0
const ACCEL: float = 100.0

@export var DEVICE_ID: int = -1

func get_movement_dir() -> Vector2:
  return InputMngr.get_vector(
    "move_left", "move_right",
    "move_up", "move_down",
    DEVICE_ID
  )
func get_aim_dir() -> Vector2:
  if DEVICE_ID >= 0:
    return InputMngr.get_vector(
      "aim_left", "aim_right",
      "aim_up", "aim_down",
      DEVICE_ID
    )
  
  return (get_global_mouse_position() - global_position).normalized()

const DASH_SPEED_MULT: float = 4.0
const DASH_DURATION: float = 0.1
const DASH_COOLDOWN: float = 0.5

var dash_timer: float = -0.5
var dash_dir: Vector2 = Vector2.ZERO
func handle_movement(delta: float) -> void:
  dash_timer -= delta
  
  if dash_timer > 0:
    velocity = dash_dir * SPEED * DASH_SPEED_MULT * delta * 60
  else:
    var new_v := get_movement_dir() * SPEED * delta * 60
    velocity = velocity.move_toward(
      new_v, ACCEL * delta * 60 * max(1, -velocity.dot(new_v) * 1.5)
    )
    
    if dash_timer < -DASH_COOLDOWN and InputMngr.is_action_pressed("dodge", DEVICE_ID):
      dash_dir = get_movement_dir()
      dash_timer = DASH_DURATION
    
  move_and_slide()

@export var weapon: Weapon

var weapon_cooldown: float = 0.0
func handle_weapon(delta: float) -> void:
  weapon_cooldown -= delta
  
  if weapon_cooldown < 0.0 and InputMngr.is_action_pressed("attack", DEVICE_ID):
    weapon.attack(self, get_aim_dir()) # TODO: Aim assist
    weapon_cooldown = weapon.cooldown

func _process(delta: float) -> void:
  handle_movement(delta)
  handle_weapon(delta)
