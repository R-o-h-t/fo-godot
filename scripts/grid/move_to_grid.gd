class_name MoveGrid
extends Node2D

var AddInputAction = preload("res://scripts/util/add_input_action.gd")

@export var movement_component: MovementComponent

@export var highlight_marker: Sprite2D

@export var active_layer: GridLayer

@export var path_line_color: Color = Color(1, 0, 0, 0.5)
var path_line: Line2D

func _ready() -> void:
  if not movement_component:
    push_error("MoveGrid requires a MovementComponent to function.")
    return

  if not highlight_marker:
    push_error("MoveGrid requires a highlight marker to function.")
    return

  # Initialize the highlight marker
  highlight_marker.position = Vector2.ZERO
  highlight_marker.visible = false

  # Initialize the movement component with the player actor
  movement_component.grid = self
  movement_component._ready()

  # add a Line2D for path visualization
  path_line = Line2D.new()
  path_line.default_color = path_line_color
  path_line.width = 2.0
  path_line.visible = false
  add_child(path_line)

  # Initialize custom input actions
  _init_custom_input_actions()


func _init_custom_input_actions() -> void:
  # Add custom input actions for moving to grid positions
  AddInputAction.add_action_with_mouse_button("move_to_grid", MOUSE_BUTTON_LEFT)
  AddInputAction.add_action_with_mouse_button("context_menu", MOUSE_BUTTON_RIGHT)


func get_cell_is_occupied(cell_position: Vector2) -> bool:
  return active_layer.get_object_at(cell_position) != null

func get_cell_is_in_bounds(cell_position: Vector2) -> bool:
  return true


func get_cell_has_ground(cell_position: Vector2) -> bool:
  # Check if the cell position has ground (e.g., is a valid tile)
  var cell_data = active_layer.get_cell_tile_data(cell_position)
  return cell_data != null

func get_cell_is_valid(cell_position: Vector2) -> bool:
  # Check if the cell position is within the bounds of the grid, as a ground and is not occupied
  return get_cell_is_in_bounds(cell_position) and \
         get_cell_has_ground(cell_position) and \
         not get_cell_is_occupied(cell_position)


func get_size() -> Vector2:
  # Return the size of the grid in terms of cells
  return Vector2(active_layer.get_used_rect().size.x, active_layer.get_used_rect().size.y)


var last_grid_position: Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
  var grid_position = get_mouse_to_grid_position()
  if (grid_position != last_grid_position):
    last_grid_position = grid_position
    if (not get_cell_has_ground(grid_position)):
      highlight_marker.visible = false
      return
    # Ensure the highlight marker is visible and positioned correctly
    highlight_marker.position = active_layer.map_to_local(grid_position)
    highlight_marker.visible = true
  if Input.is_action_just_pressed("move_to_grid"):
    if get_cell_is_valid(grid_position):
      # Request the movement component to move the player to the grid position
      movement_component.request_move_to(grid_position)

  if Input.is_action_just_pressed("context_menu"):
    # Handle context menu action (e.g., show a menu at the mouse position)
    var object = active_layer.get_object_at(grid_position)
    if object:
      print("Context menu for object: ", object.name)
      # TODO: Implement context menu logic here
    else:
      print("No object found at grid position: ", grid_position)
      # TODO: Implement logic for when no object is found at the grid position

func get_mouse_to_grid_position() -> Vector2:
  var mouse_position = active_layer.get_global_mouse_position()
  # same using local_to_world
  var local_mouse_position = active_layer.to_local(mouse_position)
  # Convert the mouse position to grid coordinates
  var grid_coord = active_layer.local_to_map(local_mouse_position)
  return grid_coord


func get_is_path_visible() -> bool:
  return path_line.visible

func show_path(path: Array[Vector2]) -> void:
  if not path or path.size() == 0:
    path_line.visible = false
    return

  path_line.clear_points()
  for point in path:
    path_line.add_point(active_layer.map_to_local(point))

  path_line.visible = true
  print("Path shown on grid: ", path)


func hide_path() -> void:
  path_line.clear_points()
  path_line.visible = false
  print("Path hidden from grid.")
