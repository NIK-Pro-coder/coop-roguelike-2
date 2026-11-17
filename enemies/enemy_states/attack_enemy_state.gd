extends BaseEnemyState
class_name AttackEnemyState

func get_score(enemy: BaseEnemy) -> float:
  var distance: float = enemy.target.global_position.distance_squared_to(enemy.global_position)
  
  if distance > enemy.enemy_data.atk_range * enemy.enemy_data.atk_range:
    return 0.0
  
  return 1.0

func process_state(enemy: BaseEnemy, _delta: float) -> void:
  enemy.attack(func():
    print("attack")
  )
