extends Node

func _ready() -> void:
  process_mode = Node.PROCESS_MODE_ALWAYS
  process_priority = 1024

func action_strength(action_name: String, device: int) -> float:
  var strength: float = 0.0
  
  var events: Array[InputEvent] = InputMap.action_get_events(action_name)
  
  for i in events:
    var ev_strength: float = 0.0
    
    if device == -1:
      if i is InputEventKey:
        ev_strength = Input.is_physical_key_pressed(i.physical_keycode)
      elif i is InputEventMouseButton:
        ev_strength = Input.is_mouse_button_pressed(i.button_index)
    else:
      if i is InputEventJoypadButton:
        ev_strength = Input.is_joy_button_pressed(device, i.button_index)
      elif i is InputEventJoypadMotion:
        var v: float = Input.get_joy_axis(device, i.axis) / i.axis_value
        ev_strength = v if v > .25 else 0.0
    
    if ev_strength > strength: strength = ev_strength
  
  return strength

func is_action_pressed(action_name: String, device: int) -> bool:
  return action_strength(action_name, device) > .5

func get_axis(positive: String, negative: String, device: int) -> float:
  return action_strength(positive, device) - action_strength(negative, device)

func get_vector(pos_x: String, neg_x: String, pos_y: String, neg_y: String, device: int) -> Vector2:
  return Vector2(
    get_axis(pos_x, neg_x, device),
    get_axis(pos_y, neg_y, device),
  ).normalized()
