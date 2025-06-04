static func add_action_with_keycode(action, key):
  var event = InputEventKey.new()
  event.physical_keycode = key
  InputMap.add_action(action)
  InputMap.action_add_event(action, event)


static func add_action_with_mouse_button(action, button):
  var event = InputEventMouseButton.new()
  event.button_index = button
  InputMap.add_action(action)
  InputMap.action_add_event(action, event)
