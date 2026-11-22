extends CharacterBody2D
class_name BaseEnemy

@onready var attack_indicator: Sprite2D = %AttackIndicator
@onready var sprite: AnimatedSprite2D = %Sprite
@onready var collision: CollisionShape2D = %Collision
@onready var hurtbox_collision: CollisionShape2D = %HurtboxCollision
@onready var nav_agent: NavigationAgent2D = %NavAgent

@export var enemy_data: EnemyData

var health: int = 0

var windup: float = 0.0
var cooldown: float = 0.0

func _ready() -> void:
  # Setup enemy from EnemyData resource
  
  enemy_data = enemy_data.duplicate(true)
  
  collision.shape = enemy_data.collision
  hurtbox_collision.shape = enemy_data.collision
  
  sprite.sprite_frames = enemy_data.sprite_frames
  sprite.scale = enemy_data.scale
  
  health = enemy_data.health

var target: Player
var retarget_timeout: float = 0.0
func retarget() -> void:
  if retarget_timeout > 0.0: return
  
  retarget_timeout = 1.0
  
  target = null
  for i: Player in get_tree().get_nodes_in_group("player"):
    if target == null or target.global_position.distance_squared_to(global_position) > i.global_position.distance_squared_to(global_position):
      target = i

var state_time: float = 0.0
var current_state: BaseEnemyState

var attack_windup: float = 0.0
var attack_cooldown: float = 0.0
var attack_callable: Callable
@warning_ignore("unused_parameter")
func attack(what: Callable):
  attack_windup = enemy_data.windup
  attack_cooldown = enemy_data.cooldown
  attack_callable = what

var move_position: Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
  if health <= 0:
    queue_free()
  
  state_time -= delta
  
  attack_indicator.modulate.a = 0.0
  if attack_windup > 0:
    attack_windup -= delta
    attack_indicator.modulate.a = 1 - (attack_windup / enemy_data.windup)
    
    if attack_windup <= 0:
      attack_callable.call()
    return
  
  if attack_cooldown > 0:
    attack_cooldown -= delta
    return
  
  retarget()
  
  if !target: return
  
  if state_time <= 0:
    var best_score: float = -1.0
    
    var weight_sum: int = 0
    
    for i in enemy_data.states:
      weight_sum += i.state_weight
    
    for i in enemy_data.states:
      var s = i.get_score(self) * i.state_weight / weight_sum
      
      if s > best_score:
        best_score = s
        current_state = i
    
    state_time = 0.25 # Minimum duration
    
  current_state.process_state(self, delta)
  
  nav_agent.target_position = move_position
  
  var p_delta: Vector2 = nav_agent.get_next_path_position() - global_position
  velocity = velocity.move_toward(
    p_delta.normalized() * enemy_data.speed * delta * 60,
    enemy_data.speed * delta * 15
  )

  move_and_slide()
