extends BaseEnemyState
class_name ChaseEnemyState

@export var min_distance: float = -1.0
@export var until_can_see: bool = false

func get_score(enemy: BaseEnemy) -> float:
  var distance: float = enemy.target.global_position.distance_squared_to(enemy.global_position)
  
  if min_distance >= 0 and distance < min_distance * min_distance and (!enemy.sight.is_colliding() or !until_can_see):
    return 0

  return 1.0

func process_state(enemy: BaseEnemy, _delta: float) -> void:
  enemy.move_position = enemy.target.global_position
