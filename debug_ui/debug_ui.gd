extends Control
class_name DebugUI

@onready var freeze_enemies: CheckButton = %FreezeEnemies
@onready var visible_aim_assist: CheckButton = %VisibleAimAssist

signal set_freeze_enemies(on: bool)
signal set_visible_aim_assist(on: bool)

func _ready() -> void:
  freeze_enemies.toggled.connect(func(on: bool):
    set_freeze_enemies.emit(on)
    freeze_enemies.release_focus()
  )
  visible_aim_assist.toggled.connect(func(on: bool):
    set_visible_aim_assist.emit(on)
    visible_aim_assist.release_focus()
  )
