extends Node2D

const DEBUG_UI = preload("uid://dfk1vx5i3132l")

var debug_ui: DebugUI

var enemies_frozen: bool = false
var aim_assist_visible: bool = false

var overlay_visible: bool = false

func _ready() -> void:
  process_mode = Node.PROCESS_MODE_ALWAYS
  z_index = 4096
  debug_ui = DEBUG_UI.instantiate()
  debug_ui.visible = false
  
  debug_ui.set_freeze_enemies.connect(func(on: bool): enemies_frozen = on)
  debug_ui.set_visible_aim_assist.connect(func(on: bool): aim_assist_visible = on)
  
  add_child(debug_ui)

var lines: Array[Dictionary] = []
var circles: Array[Dictionary] = []
var strings: Array[Dictionary] = []

func line(from: Vector2, to: Vector2, col: Color = Color.RED) -> void:
  lines.append({
    "from": from,
    "to": to,
    "col": col
  })

func circle(center: Vector2, radius: float, col: Color = Color.RED, filled: bool = false) -> void:
  circles.append({
    "center": center,
    "radius": radius,
    "col": col,
    "filled": filled
  })

func string(text: Variant, pos: Vector2, col: Color = Color.WHITE) -> void:
  strings.append({
    "pos": pos,
    "text": str(text),
    "col": col
  })

func _draw() -> void:
  if overlay_visible:
    for l in lines: draw_line(l.from, l.to, l.col)
    for c in circles: draw_circle(c.center, c.radius, c.col, c.filled)
    for s in strings: draw_string(
      ThemeDB.fallback_font, 
      s.pos, 
      s.text, 
      HorizontalAlignment.HORIZONTAL_ALIGNMENT_LEFT, 
      -1, 
      8,
      s.col
    )
  
  lines.clear()
  circles.clear()
  strings.clear()

func _process(_delta: float) -> void:
  queue_redraw()
  if Input.is_action_just_pressed("toggle_debug"): overlay_visible = !overlay_visible

  debug_ui.visible = overlay_visible
