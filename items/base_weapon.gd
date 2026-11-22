extends Item
class_name Weapon

@export var cooldown: float = 0.0
@export var spawn_scene: PackedScene
@export var bullet_amount: int = 1
@export var bullet_spread: float = 0.0
@export var rotate_to_aim: bool = false
@export var spawn_at_player: bool = false
@export var extra_args: Dictionary[String, Variant] = {}

func attack(player: Player, dir: Vector2) -> void:
  for i in range(bullet_amount):
    var b: Node2D = spawn_scene.instantiate()
    
    if spawn_at_player: b.global_position = player.global_position
    if rotate_to_aim: b.rotation = dir.angle()
    
    b.rotation += (i - (bullet_amount - 1.0) / 2) * bullet_spread
    
    for k in extra_args:
      b[k] = extra_args[k]
    
    player.get_tree().get_root().add_child(b)
