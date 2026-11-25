extends Node

const ROOM_TRANSITION = preload("uid://bbbg7ptus64a8")

var map: Map

func _ready() -> void:
  map = MapMngr.create_map()
  
  SignalBus.room_cleared.connect(spawn_room_transitions)

  enter_room(map.rooms[0])

func enter_room(room: Room) -> void:
  SignalBus.room_entered.emit(room)

func spawn_room_transitions(room: Room) -> void:
  var spawn_pos: Vector2 = get_viewport().get_camera_2d().global_position
  var edges: PackedInt64Array = map.edges[map.rooms.find(room)]

  var transitions: Array[RoomTransition] = []

  for i in range(len(edges)):
    var r: RoomTransition = ROOM_TRANSITION.instantiate()
    r.global_position = spawn_pos + Vector2(150, 0) * (float(i) - float(len(edges) - 1) / 2)
    r.room = map.rooms[i]
    r.room_name = Room.RoomTypes.keys()[r.room.type]

    transitions.push_back(r)

    get_tree().get_root().add_child.call_deferred(r)

  for i in transitions:
    i.player_touched.connect(func():
      enter_room(i.room)
      for t in transitions:
        t.queue_free()
    )
