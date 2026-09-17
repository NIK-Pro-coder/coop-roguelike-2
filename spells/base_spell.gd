class_name Spell extends Item

@export var soul_cost: float = 0.0

enum TargetType {
  Enemies,
  Players,
  Self
}

@export var target_type: TargetType
@export var what_to_spawn: PackedScene
@export var spawn_on_target: bool = false
@export var max_range: float = -1

func cast_spell(player: Player, cast_dir: Vector2) -> void:
  if soul_cost > player.soul:
    return
  
  print(cast_dir)

  var targets: Array[Node] = []
  
  if target_type == TargetType.Enemies:
    targets = player.get_tree().get_nodes_in_group("enemy")
  elif target_type == TargetType.Players:
    targets = player.get_tree().get_nodes_in_group("player")
    targets.erase(player)
  else:
    targets = [player]
  
  print(targets)
