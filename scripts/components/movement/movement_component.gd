class_name MovementComponent
extends Node

@export var actor: Actor

var grid: MoveGrid

var _is_moving: bool = false
var _path: Array[Vector2] = []

var _movement_points: int = -1


func _ready() -> void:
  if not actor:
    push_error("MovementComponent requires an Actor to function.")
    return

func request_move_to(target_position: Vector2) -> void:
  # Request the actor to move to a new position
  if not actor:
    push_error("MovementComponent requires an Actor to function.")
    return

  # if actor.position != target_position:
  #     if grid:
  #         # Check if the target position is within the grid bounds and not occupied
  #         if not grid.get_cell_is_in_bounds(target_position) or \
  #            grid.get_cell_is_occupied(target_position) or \
  #            not grid.get_cell_has_ground(target_position):
  #             push_error("Target position is out of bounds, occupied, or has no ground.")
  #             return

  #     actor.position = grid.active_layer.map_to_local(target_position) if grid else target_position
  #     grid.active_layer.reload_object_zindex(actor)
  #     print("Requested move to position: ", target_position)
  # else:
  #     print("Actor is already at the target position: ", target_position)

  if grid && grid.active_layer:
    # Check if the target position is within the grid bounds and not occupied
    if not grid.get_cell_is_in_bounds(target_position) or \
       grid.get_cell_is_occupied(target_position) or \
       not grid.get_cell_has_ground(target_position):
      push_error("Target position is out of bounds, occupied, or has no ground.")
      return

    print("Requesting move to position: ", target_position)

    var path = grid.active_layer.astar_grid.get_navigation_path(
      grid.active_layer.get_position_of(actor),
      target_position
    )
    if path and path.size() > 0:
      print("Path found: ", path)
      _is_moving = true
      # if more points than _movement_points, trim the path
      if path.size() > _movement_points:
        path = path.slice(0, _movement_points)
      _path = path
    else:
      print("No valid path found to target position: ", target_position)
      return


func _process(delta: float) -> void:
  # if path show it on the grid
  if grid:
    if _path.size() > 0:
      grid.show_path(_path)
    if _path.size() == 0 and !grid.get_is_path_visible():
      grid.hide_path()


  if _is_moving and actor:
    # Move the actor along the path
    if _path.size() > 0 and _movement_points != 0:
      var next_position = grid.active_layer.map_to_local(_path.front())
      if next_position != actor.position:
        actor.position = actor.position.move_toward(next_position, actor.speed)
      # Remove the first position from the path
      if actor.position.distance_to(next_position) < actor.speed * delta:
        _path.pop_front()
        if _movement_points > 0:
          _movement_points -= 1

      if _path.size() == 0:
        stop_moving()
    else:
      stop_moving()


func stop_moving() -> void:
  # Stop the actor from moving
  _is_moving = false
  print("Movement stopped.")

  if actor:
    print("Actor stopped at position: ", actor.position)
  else:
    push_error("MovementComponent requires an Actor to function.")


func set_movement_points(points: int) -> void:
  _movement_points = points if points >= 0 else -1
