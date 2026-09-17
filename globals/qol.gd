extends Node

func _ready() -> void: process_mode = Node.PROCESS_MODE_ALWAYS

func add_to_tree(node: Node) -> void: get_tree().get_root().add_child.call_deferred(node)

func rectangle_shape(w: float, h: float) -> RectangleShape2D:
  var r := RectangleShape2D.new()
  r.size = Vector2(w, h)
  return r

func circle_shape(r: float) -> CircleShape2D:
  var c := CircleShape2D.new()
  c.radius = r
  return c

func create_hitbox(shape: Shape2D) -> Hitbox:
  var h := Hitbox.new()
  var s := CollisionShape2D.new()
  s.shape = shape
  h.add_child(s)
  return h

func rectangle_hitbox(w: float, h: float) -> Hitbox:
  return create_hitbox(rectangle_shape(w, h))

func circle_hitbox(r: float) -> Hitbox:
  return create_hitbox(circle_shape(r))
