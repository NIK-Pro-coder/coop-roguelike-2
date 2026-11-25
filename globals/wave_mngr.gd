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

var live_enemies: int = 0:
  set(v):
    live_enemies = v
    
    if v == 0: SignalBus.wave_cleared.emit()

func spawn_enemies(budget: float) -> void:
  var spawn_pos: Vector2 = get_viewport().get_camera_2d().global_position
  
  if budget == 0:
    SignalBus.room_cleared.emit(current_room)
    return
  
  while budget > 0:
    var could: Array[EnemyData] = enemydata_resources.filter(func(x: EnemyData): return x.budget_cost <= budget)

    if len(could) <= 0: break
    
    var data: EnemyData = could.pick_random()
    var enemy: BaseEnemy = BASE_ENEMY.instantiate()
    
    enemy.enemy_data = data
    enemy.global_position = spawn_pos + Vector2.from_angle(randf_range(-PI, PI)) * randf_range(0, 250)
    budget -= data.budget_cost
    
    live_enemies += 1
    enemy.died.connect(func(): live_enemies -= 1)
    
    get_tree().get_root().add_child.call_deferred(enemy)

var base_budget: float = 5.0
var current_room: Room
var waves_to_spawn: int = 0

func spawn_wave() -> void:
  if waves_to_spawn <= 0:
    SignalBus.room_cleared.emit(current_room)
    return
  
  SignalBus.wave_started.emit()
  waves_to_spawn -= 1
  spawn_enemies(base_budget * current_room.budget_mult())

func on_room_enter(room: Room) -> void:
  current_room = room
  waves_to_spawn = 3
  spawn_wave()

func _ready() -> void:
  load_enemydata()
  SignalBus.room_entered.connect(on_room_enter)
  SignalBus.wave_cleared.connect(spawn_wave)
