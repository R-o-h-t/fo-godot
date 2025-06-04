class_name MoveGrid
extends TileMapLayer

var AddInputAction = preload("res://scripts/util/add_input_action.gd")


@export var movement_component: MovementComponent
@export var player: Actor

@export var highlight_marker: Sprite2D

# size of the grid (number of cells)
@export var grid_size: Vector2 = Vector2(32, 32)

func _ready() -> void:
  if not movement_component:
    push_error("MoveGrid requires a MovementComponent to function.")
    return

  if not player:
    push_error("MoveGrid requires an Actor to function.")
    return

  if not highlight_marker:
    push_error("MoveGrid requires a highlight marker to function.")
    return

  # Initialize the highlight marker
  highlight_marker.position = Vector2.ZERO
  highlight_marker.visible = false

  # Initialize the movement component with the player actor
  movement_component.actor = player
  movement_component.grid = self
  movement_component._ready()

  # Initialize custom input actions
  _init_custom_input_actions()


func _init_custom_input_actions() -> void:
  # Add custom input actions for moving to grid positions
  AddInputAction.add_action_with_mouse_button("move_to_grid", MOUSE_BUTTON_LEFT)


func get_cell_is_occupied(cell_position: Vector2) -> bool:
  # TODO : Implement logic to check if the cell is occupied
  return false

func get_cell_is_in_bounds(cell_position: Vector2) -> bool:
  return true
  # # Check if the cell position is within the bounds of the grid
  # return cell_position.x >= 0 and cell_position.y >= 0 and \
  #        cell_position.x < get_size().x * grid_size.x and \
  #        cell_position.y < get_size().y * grid_size.y

func get_cell_has_ground(cell_position: Vector2) -> bool:
  # Check if the cell position has ground (e.g., is a valid tile)
  var cell_data = get_cell_tile_data(cell_position)
  return cell_data != null

func get_cell_is_valid(cell_position: Vector2) -> bool:
  # Check if the cell position is within the bounds of the grid, as a ground and is not occupied
  return get_cell_is_in_bounds(cell_position) and \
         get_cell_has_ground(cell_position) and \
         not get_cell_is_occupied(cell_position)


func get_size() -> Vector2:
  # Return the size of the grid in terms of cells
  return Vector2(get_used_rect().size.x, get_used_rect().size.y)


var last_grid_position: Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
  var grid_position = get_mouse_to_grid_position()
  if (grid_position != last_grid_position):
    last_grid_position = grid_position
    if (not get_cell_is_valid(grid_position)):
      highlight_marker.visible = false
      return
    # Ensure the highlight marker is visible and positioned correctly
    highlight_marker.position = map_to_local(grid_position)
    highlight_marker.visible = true
  if Input.is_action_just_pressed("move_to_grid"):
    if get_cell_is_valid(grid_position):
      # Request the movement component to move the player to the grid position
      movement_component.request_move_to(grid_position)
      print("Requested move to grid position: ", grid_position)
    else:
      print("Invalid grid position: ", grid_position)
      highlight_marker.visible = false


func get_mouse_to_grid_position() -> Vector2:
  var mouse_position = get_global_mouse_position()
  # same using local_to_world
  var local_mouse_position = to_local(mouse_position)
  # Convert the mouse position to grid coordinates
  print("Mouse position: ", mouse_position, " Local mouse position: ", local_mouse_position)
  var grid_coord = local_to_map(local_mouse_position)
  print("Grid coordinate: ", grid_coord)
  return grid_coord
