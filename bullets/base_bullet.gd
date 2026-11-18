extends CharacterBody2D
class_name BaseBullet

@export var speed: float
@export var damage: int

@export var local_duration: float = 0.0

@onready var hitbox: Hitbox = %Hitbox

func _ready() -> void:
  hitbox.local_duration = local_duration

func _process(delta: float) -> void:
  velocity = Vector2.from_angle(rotation) * speed * delta * 60

  move_and_slide()

func _on_hitbox_hit_node(node: Node) -> void:
  if node is BaseEnemy:
    node.health -= damage
