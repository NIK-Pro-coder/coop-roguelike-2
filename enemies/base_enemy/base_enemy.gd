class_name BaseEnemy extends CharacterBody2D

@onready var retarget_timer: Timer = %RetargetTimer
@onready var hurtbox: Hurtbox = %Hurtbox

var speed: float = 150

func get_closest_player() -> Player:
  var c_player: Player
  var c_dist: float = -1
  
  for i: Player in get_tree().get_nodes_in_group("player"):
    var d := global_position.distance_squared_to(i.global_position)
    
    if d < c_dist or c_dist < 0:
      c_dist = d
      c_player = i
  
  return c_player

var target: Player

func retarget() -> void:
  target = get_closest_player()

func _ready() -> void:
  retarget_timer.timeout.connect(retarget)
  
  hurtbox.died.connect(queue_free)
  hurtbox.hit.connect(on_hit)

func on_hit(_dmg: float, new_hitstun: float) -> void:
  hitstun = max(new_hitstun, hitstun + new_hitstun)

func handle_movement(delta: float) -> void:
  if !target: return
  
  velocity = (target.global_position - global_position).normalized() * speed * delta * 60
  
  move_and_slide()

var hitstun: float = 0.0

func _process(delta: float) -> void:
  hitstun -= delta
  
  if hitstun <= 0.0:
    handle_movement(delta)
