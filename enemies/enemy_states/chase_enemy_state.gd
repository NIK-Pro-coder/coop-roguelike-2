extends BaseEnemyState
class_name ChaseEnemyState

@export var max_distance: float = -1.0

func get_score(enemy: BaseEnemy) -> float:
  var distance: float = enemy.target.global_position.distance_to(enemy.global_position)
  
  if max_distance >= 0 and distance > max_distance * max_distance:
    return 0

  return 1.0

func process_state(enemy: BaseEnemy, delta: float) -> void:
  var dir := (enemy.target.global_position - enemy.global_position).normalized()
  enemy.velocity = dir * enemy.enemy_data.speed * delta * 60
  enemy.move_and_slide()
