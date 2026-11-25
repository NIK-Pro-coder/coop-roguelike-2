extends Area2D
class_name RoomTransition

@onready var label: Label = %Label

signal player_touched

@export var room_name: String
@export var room: Room

var can_touch: bool = false

func _on_body_entered(_body: Node2D) -> void:
  if !can_touch: return

  player_touched.emit()

func _ready() -> void:
  label.text = "Go to %s room" % room_name

func _on_timer_timeout() -> void:
  can_touch = true
