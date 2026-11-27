extends Resource
class_name BaseEnemyState

@export var state_weight: float = 1

@warning_ignore_start("unused_parameter")
func get_score(enemy: BaseEnemy) -> float:
  return 0.0
func process_state(enemy: BaseEnemy, delta: float) -> void:
  pass
@warning_ignore_restore("unused_parameter")
