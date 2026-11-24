extends Node

func _ready() -> void:
  SignalBus.room_entered.connect(on_room_enter)

func on_room_enter(room: Room) -> void:
  print(room)
