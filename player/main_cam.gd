class_name MainCam extends Camera2D

const MIN_MOVE_DIST: float = 1.0

const PADDING: float = 100.0

const ZOOM_MIN: float = .2
const ZOOM_MAX: float = 1.0

func _process(_a: float) -> void:
  var players: Array[Node] = get_tree().get_nodes_in_group("player")
  
  var target_pos: Vector2 = Vector2.ZERO
  
  for i: Player in players:
    target_pos += i.global_position / len(players)
  
  var diff: Vector2 = target_pos - global_position

  if diff.length_squared() < MIN_MOVE_DIST * MIN_MOVE_DIST:
    global_position = target_pos 
  else:
    global_position = global_position * .9 + target_pos * .1

  var target_zoom: float = ZOOM_MAX

  var w = get_viewport_rect().size.x - PADDING
  var h = get_viewport_rect().size.y - PADDING

  for i: Player in players :
    var delta = i.global_position - target_pos
    var zx: float = w / (abs(delta.x)*2)
    var zy: float = h / (abs(delta.y)*2)
    
    target_zoom = min(target_zoom, zx)
    target_zoom = min(target_zoom, zy)
  
  target_zoom = clamp(target_zoom, ZOOM_MIN, ZOOM_MAX)

  zoom = zoom * .9 +  Vector2(target_zoom, target_zoom) * .1
