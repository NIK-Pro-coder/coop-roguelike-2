extends Node

const BASE_ENEMY = preload("uid://jn5yuvc2vbf8")
const ENEMYDATA_PATH: String = "res://enemies/enemy_data/"

var enemydata_resources: Array[EnemyData] = []
func load_enemydata() -> void:
  print("Loading enemies")
  enemydata_resources.clear()
  
  var enemies: PackedStringArray = ResourceLoader.list_directory(ENEMYDATA_PATH)

  for e in enemies:
    var res: Resource = load(ENEMYDATA_PATH.path_join(e))
    
    if res is EnemyData:
      print(" - Loaded enemy: %s" % res.name)
      enemydata_resources.push_back(res)

func spawn_enemies(budget: float) -> void:
  var spawn_pos: Vector2 = get_viewport().get_camera_2d().global_position
  
  while budget > 0:
    var could: Array[EnemyData] = enemydata_resources.filter(func(x: EnemyData): return x.budget_cost <= budget)

    if len(could) <= 0: break
    
    var data: EnemyData = could.pick_random()
    var enemy: BaseEnemy = BASE_ENEMY.instantiate()
    
    enemy.enemy_data = data
    enemy.global_position = spawn_pos + Vector2.from_angle(randf_range(-PI, PI)) * randf_range(0, 250)
    budget -= data.budget_cost
    
    get_tree().get_root().add_child.call_deferred(enemy)

var base_budget: float = 5.0

func on_room_enter(room: Room) -> void:
  print(room.type)
  print(room.budget_mult())
  spawn_enemies(base_budget * room.budget_mult())

func _ready() -> void:
  load_enemydata()
  SignalBus.room_entered.connect(on_room_enter)
