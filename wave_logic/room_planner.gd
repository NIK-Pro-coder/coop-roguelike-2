extends Node
class_name RoomPlanner

const ENEMY_DATA_PATH: String = "res://enemies/enemy_data/"
const ROOM_BUDGET_MULT: Dictionary[RoomType, float] = {
  RoomType.Special: 0.0,
  RoomType.Normal:  1.0,
  RoomType.Mid:     1.15,
  RoomType.Twist:   1.1,
  RoomType.Elite:   1.15,
  RoomType.Hard:    1.25,
}

enum RoomType {
  Normal,
  Mid,
  Hard,
  Twist,
  Elite,
  Special,
  Boss,
  Start,
}

class Room:
  var type: RoomType
  var connected: Array[int]

var enemy_data_resources: Array[EnemyData] = []

func _ready() -> void:
  load_enemies()
  plan_rooms()

func load_enemies() -> void:
  var enemy_paths: PackedStringArray = ResourceLoader.list_directory(ENEMY_DATA_PATH)

  for i in enemy_paths:
    var res := load(ENEMY_DATA_PATH.path_join(i))
    if res is EnemyData: enemy_data_resources.append(res)

func plan_rooms() -> void:
  var structure: Array[int] = [1]
  for i in range(4): structure.push_back(randi_range(2, 3))
  
  var room_order: Array[int] = [] # Enum keys are ints
  var rooms: Array[Room] = []
  
  for i in range(len(structure)):
    for l in range(structure[i]):
      var r: Room = Room.new()
      
      if len(room_order) == 0:
        room_order = ROOM_BUDGET_MULT.keys()
        room_order.shuffle()
      
      if len(rooms) == 0:
        r.type = RoomType.Start
      else:
        r.type = room_order.pop_back()
      
      var less: int = l - randi_range(0, 1)
      var more: int = l + randi_range(0, 1)
      
      print(less, " ", more)
      
      rooms.push_back(r)

  rooms.push_back(Room.new())
  rooms[-1].type = RoomType.Boss

  for i in rooms:
    print(i.type)
