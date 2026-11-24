extends Node

var map: Map

func _ready() -> void:
  map = MapMngr.create_map()
  SignalBus.room_entered.emit(map.rooms[0])
