class_name WeaponItem extends Item

@export var cooldown: float = 0.0
@export var damage: float = 0.0
@export var area: float = 0.0

@warning_ignore("unused_parameter")
func attack(player: Player, direction: Vector2) -> void:
  pass
