extends Node2D

func _ready() -> void:
  process_mode = Node.PROCESS_MODE_ALWAYS
  z_index = 4096

var lines: Array[Dictionary] = []
var circles: Array[Dictionary] = []

func line(from: Vector2, to: Vector2, col: Color = Color.RED) -> void:
  if !OS.is_debug_build(): return
  
  lines.append({
    "from": from,
    "to": to,
    "col": col
  })

func circle(center: Vector2, radius: float, col: Color = Color.RED) -> void:
  if !OS.is_debug_build(): return
  
  circles.append({
    "center": center,
    "radius": radius,
    "col": col
  })

func _draw() -> void:
  for l in lines: draw_line(l.from, l.to, l.col)
  for c in circles: draw_circle(c.center, c.radius, c.col)
  
  lines.clear()
  circles.clear()

func _process(_delta: float) -> void:
  queue_redraw()
