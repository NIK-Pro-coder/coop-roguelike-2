extends Node

func _ready() -> void:
  process_mode = Node.PROCESS_MODE_ALWAYS

func is_action_pressed(action: String, device: int) -> float:
  var events = InputMap.action_get_events(action)
  var deadzone = InputMap.action_get_deadzone(action)
  
  for i in events:
    if device == -1:
      if i is InputEventKey:
        return 1.0 if Input.is_physical_key_pressed(i.physical_keycode) else 0.0
    elif device >= 0:
      if i is InputEventJoypadButton:
        return 1.0 if Input.is_joy_button_pressed(device, i.button_index) else 0.0
      elif i is InputEventJoypadMotion:
        var v = Input.get_joy_axis(device, i.axis) / i.axis_value
        return v if v > deadzone else 0.0

  return 0.0

func get_axis(neg_action: String, pos_action: String, device: int) -> float:
  return is_action_pressed(pos_action, device) - is_action_pressed(neg_action, device)

func get_vector(negative_x: String, positive_x: String, negative_y: String, positive_y: String, device: int) -> Vector2:
  var v = Vector2(
    get_axis(negative_x, positive_x, device),
    get_axis(negative_y, positive_y, device),
  )
  
  if v.length() > 0: return v.normalized()

  return v
