class_name AStar2DHex
extends AStar2D

var _grid_layer: GridLayer

# dictionary to store cell IDs
var _cell_ids: Dictionary = {}

func _init(grid_layer: GridLayer) -> void:
  if not grid_layer:
    push_error("AStar2DHex requires a valid GridLayer to function.")
    return
  _grid_layer = grid_layer
  var cells = _grid_layer.get_used_cells()
  for cell in cells:
    get_cell_id(cell)

  connect_cells()


func connect_cells() -> void:
  if not _grid_layer:
    push_error("AStar2DHex requires a valid GridLayer to function.")
    return

  var cells = _grid_layer.get_used_cells()
  for cell in cells:
    var cell_id = get_cell_id(cell)
    var connected_cells = _grid_layer.get_connected_cells(cell)
    for connected_cell in connected_cells:
      var connected_cell_id = get_cell_id(connected_cell)
      connect_points(cell_id, connected_cell_id, false)

func get_cell_id(cell: Vector2) -> int:
  # Generate a unique ID for the cell based on its coordinates
  if not _cell_ids.has(cell):
    _cell_ids[cell] = _cell_ids.size() + 1 # Start IDs from 1
    add_point(_cell_ids[cell], cell)
  return _cell_ids[cell]


func get_navigation_path(from: Vector2, to: Vector2) -> Array[Vector2]:
  var path: Array[Vector2] = []
  if not _grid_layer:
    push_error("AStar2DHex requires a valid GridLayer to function.")
    return path

  var from_id = get_cell_id(from)
  var to_id = get_cell_id(to)

  if not has_point(from_id) or not has_point(to_id):
    push_error("Invalid start or end point for pathfinding.")
    return path

  var astar_path = get_point_path(from_id, to_id)
  for cell in astar_path:
    path.append(cell)

  return path
