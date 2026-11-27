extends CharacterBody2D
class_name Player

const SPEED: float = 250.0
const ACCEL: float = 50.0

@onready var hurtbox: Hurtbox = %Hurtbox

@export var DEVICE_ID: int = -1

func get_movement_dir() -> Vector2:
  return InputMngr.get_vector(
    "move_left", "move_right",
    "move_up", "move_down",
    DEVICE_ID
  )

const MIN_AIM_ASSIST_DOT: float = .95
const MAX_RAD_ASSIST: float = deg_to_rad(7)
func get_aim_dir() -> Vector2:
  if DEVICE_ID < 0:
    return (get_global_mouse_position() - global_position).normalized()

  var base_vec: Vector2 = InputMngr.get_vector(
      "aim_left", "aim_right",
      "aim_up", "aim_down",
      DEVICE_ID
    )

  if DebugMngr.aim_assist_visible:
    DebugMngr.line(
      global_position,
      global_position + base_vec * 250,
      Color.GREEN
    )
    DebugMngr.line(
      global_position,
      global_position + base_vec.rotated(acos(MIN_AIM_ASSIST_DOT)) * 500,
      Color.BLUE
    )
    DebugMngr.line(
      global_position,
      global_position + base_vec.rotated(-acos(MIN_AIM_ASSIST_DOT)) * 500,
      Color.BLUE
    )

  var c_enemy: BaseEnemy
  var c_cross: float = -1.0

  for i: BaseEnemy in get_tree().get_nodes_in_group("enemy"):
    var delta: Vector2 = i.global_position - global_position
    var dot: float = delta.normalized().dot(base_vec)
    if dot <= MIN_AIM_ASSIST_DOT: continue
    
    var cross: float = abs(delta.cross(base_vec))
    
    if DebugMngr.aim_assist_visible:
      DebugMngr.line(global_position,i.global_position)
      DebugMngr.string(cross, i.global_position + Vector2(0, 10))
  
    if cross < c_cross or c_cross < 0:
      c_cross = cross
      c_enemy = i

  if c_enemy:
    var delta: Vector2 = c_enemy.global_position - global_position
    var angle_off: float = base_vec.angle_to(delta)
    
    var new_v: Vector2 = base_vec.rotated(
      clamp(angle_off, -MAX_RAD_ASSIST, MAX_RAD_ASSIST)
    )
    
    if DebugMngr.aim_assist_visible:
      DebugMngr.line(global_position, global_position + new_v * 250, Color.ORANGE)
      DebugMngr.circle(c_enemy.global_position, 30)
      DebugMngr.string(rad_to_deg(angle_off), c_enemy.global_position + Vector2(0, 20))
    
    return new_v

  return base_vec

const DASH_SPEED_MULT: float = 2.75
const DASH_DURATION: float = 0.3
const DASH_COOLDOWN: float = 0.25

var dash_timer: float = -0.5
var dash_dir: Vector2 = Vector2.ZERO
var was_dashing: bool = false
func handle_movement(delta: float) -> void:
  dash_timer -= delta
  hurtbox.active = dash_timer <= 0
  
  if dash_timer > 0:
    velocity = dash_dir * SPEED * DASH_SPEED_MULT * delta * 60
    was_dashing = true
  else:
    if was_dashing:
      was_dashing = false
      velocity = velocity.normalized() * SPEED
    
    var new_v := get_movement_dir() * SPEED * delta * 60
    velocity = velocity.move_toward(
      new_v, ACCEL * delta * 60 * max(1, -velocity.dot(new_v) * 1.5)
    )
    
    if dash_timer < -DASH_COOLDOWN and InputMngr.is_action_pressed("dash", DEVICE_ID) and get_movement_dir():
      dash_dir = get_movement_dir()
      dash_timer = DASH_DURATION
    
  move_and_slide()

@export var weapon: Weapon

var weapon_cooldown: float = 0.0
func handle_weapon(delta: float) -> void:
  weapon_cooldown -= delta
  
  var aim_dir: Vector2 = get_aim_dir()
  
  if weapon_cooldown < 0.0 and InputMngr.is_action_pressed("attack", DEVICE_ID):
    weapon.attack(self, aim_dir)
    weapon_cooldown = weapon.cooldown

@onready var health_bar: ProgressBar = %HealthBar

var hp_visible: float = 0.0

func _process(delta: float) -> void:
  handle_movement(delta)
  handle_weapon(delta)

  if Input.is_action_pressed("interact"): hp_visible = max(.5, hp_visible)
  
  hp_visible -= delta
  health_bar.modulate.a = health_bar.modulate.a * .9 + (.1 if hp_visible > 0 else 0.0)
  health_bar.value = health_bar.value * .75 + health * .25

var max_health: int = 10
var health: int = 0:
  set(v):
    health = v
    hp_visible = 2.5

func _ready() -> void:
  health = max_health
  hp_visible = 0
