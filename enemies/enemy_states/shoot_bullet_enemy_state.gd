extends BaseAttackEnemyState
class_name ShootBulletEnemyState

const EVIL_BULLET = preload("uid://dfl8dx6boyjfa")

func attack(enemy: BaseEnemy) -> void:
  var s: BaseBullet = EVIL_BULLET.instantiate()
  s.global_position = enemy.global_position
  s.global_rotation = (enemy.target.global_position - enemy.global_position).angle()
  s.damage = enemy.enemy_data.damage
  
  enemy.get_tree().get_root().add_child.call_deferred(s)
