class_name InteractiveCamera
extends Camera2D


const AddInputAction = preload("res://scripts/util/add_input_action.gd")

@export var zoom_speed: float = 1
@export var move_speed: float = 100.0

@export var max_zoom: float = 5.0
@export var max_unzoom: float = 0.2

@export var target_actor: Actor = null

var drag_cursor_shape: bool = false
var zoom_percentage: float = 10.0

func _input(event):
  if event is InputEventMouseMotion:
    if event.button_mask == MOUSE_BUTTON_MASK_MIDDLE:
      # position -= event.relative / zoom
      _change_position(position - event.relative / zoom)
      drag_cursor_shape = true
    else:
      drag_cursor_shape = false

  if event is InputEventMouseButton:
    if event.is_pressed():
      if event.button_index == MOUSE_BUTTON_WHEEL_UP:
        zoom += Vector2.ONE * zoom_percentage / 100
        if zoom.x > max_zoom:
          zoom = Vector2.ONE * max_zoom
          return
        # position += get_local_mouse_position() / 10
        _change_position(position + get_local_mouse_position() / 10)
      if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
        zoom -= Vector2.ONE * zoom_percentage / 100
        if zoom.x < max_unzoom:
          zoom = Vector2.ONE * max_unzoom

func _process(delta):
  if target_actor and _following:
    position = target_actor.position

  if Input.is_action_pressed("follow"):
    follow()

  if drag_cursor_shape:
    DisplayServer.cursor_set_shape(DisplayServer.CURSOR_DRAG)

  if Input.is_action_pressed("ui_up"):
    # position.y -= move_speed * delta
    _change_position(position + Vector2(0, -move_speed * delta))
  if Input.is_action_pressed("ui_down"):
    # position.y += move_speed * delta
    _change_position(position + Vector2(0, move_speed * delta))
  if Input.is_action_pressed("ui_left"):
    # position.x -= move_speed * delta
    _change_position(position + Vector2(-move_speed * delta, 0))
  if Input.is_action_pressed("ui_right"):
    # position.x += move_speed * delta
    _change_position(position + Vector2(move_speed * delta, 0))


# A camera that can be controlled :
  # using arrows or WASD keys - move the camera
  # using mouse wheel - zoom in and out

# Camera can also be set as "following" a target actor


var _following: bool = false

func follow() -> void:
  if target_actor:
    _following = true
    position = target_actor.position
  else:
    push_error("No target actor set for following.")

func _change_position(new_position: Vector2) -> void:
  if _following:
    _following = false
  position = new_position


func _ready() -> void:
  # Ensure the camera starts with a default zoom
  zoom = Vector2(1, 1)

  AddInputAction.add_action_with_keycode("follow", KEY_F)
