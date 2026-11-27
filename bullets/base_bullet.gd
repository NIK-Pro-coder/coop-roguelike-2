extends CharacterBody2D
class_name BaseBullet

@export var speed: float
@export var damage: int

@export var local_duration: float = 0.0

@export var spectral: bool = false
@export var piercing: int = 0

@onready var hitbox: Hitbox = %Hitbox

func _ready() -> void:
  hitbox.local_duration = local_duration
  if spectral: collision_mask = 0

func _process(delta: float) -> void:
  var v = Vector2.from_angle(rotation) * speed * delta * 60

  velocity = v

  move_and_slide()
  
  if velocity != v: queue_free()

func _on_hitbox_hit_node(node: Node) -> void:
  piercing -= 1
  if piercing == -1: queue_free()
  
  if node is BaseEnemy:
    node.health -= damage
  elif node is Player:
    node.health -= damage
