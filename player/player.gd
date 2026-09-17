class_name Player extends CharacterBody2D

@export var device_id: int = -1

@export var melee_weapon: WeaponItem

var speed: float = 250.0
var last_move_dir: Vector2 = Vector2.ZERO

func handle_movement(delta: float) -> void:
  var dir := MultiInput.get_vector(
    "right", "left",
    "down", "up",
    device_id
  )
  
  if !dir: return
  
  last_move_dir = dir
  
  velocity = dir * speed * delta * 60
  
  move_and_slide()

var melee_weapon_cooldown: float = 0.0

func handle_attack(delta: float) -> void:
  melee_weapon_cooldown -= delta
  
  if melee_weapon_cooldown > 0: return
  
  if MultiInput.is_action_pressed("attack", device_id):
    var direction: Vector2 = Vector2.ZERO
    
    if device_id < 0:
      direction = (get_global_mouse_position() - global_position).normalized()
    else:
      direction = last_move_dir
    
    if !direction: return
    
    melee_weapon.attack(self, direction)
    melee_weapon_cooldown = melee_weapon.cooldown

func _process(delta: float) -> void:
  handle_movement(delta)
  handle_attack(delta)
