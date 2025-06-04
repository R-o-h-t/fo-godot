class_name GridLayer
extends TileMapLayer

@export var objects: Array[CollisionObject2D] = []

func _ready() -> void:
  if not objects:
    push_error("GridLayer requires at least one CollisionObject2D to function properly.")
    return

  # Ensure all objects are valid and inside the tree
  for obj in objects:
    if not obj or not obj.is_inside_tree():
      push_error("GridLayer requires valid CollisionObject2D objects that are inside the tree.")
      return

  print("GridLayer is ready with ", objects.size(), " objects.")
  _reload_all_objects_zindex()


func get_position_of(object: CollisionObject2D) -> Vector2:
  if not object:
      push_error("GridLayer requires a valid CollisionObject2D to get position.")
      return Vector2.ZERO

  if not object.is_inside_tree():
    print("Object is not inside the tree, cannot get position.")
    return Vector2.ZERO

  return local_to_map(object.position)

func get_object_at(cell_position: Vector2) -> CollisionObject2D:
  print("Getting object at cell position: ", cell_position)
  if not cell_position:
      push_error("GridLayer requires a valid cell position to get object.")
      return null

  # Iterate through the objects to find one at the specified cell position
  for obj in objects:
      if obj and get_position_of(obj) == cell_position:
          return obj

  return null

func reload_object_zindex(object: CollisionObject2D) -> void:
  if not object or not object.is_inside_tree():
    push_error("GridLayer requires a valid CollisionObject2D that is inside the tree to reload Z index.")
    return

  # Reload the Z index of the object
  object.z_index = _get_z_index_at_position(get_position_of(object))
  print("Reloaded Z index for object at position: ", get_position_of(object), " to Z index: ", object.z_index)


func _reload_all_objects_zindex() -> void:
  if not objects or objects.is_empty():
    push_error("GridLayer requires at least one CollisionObject2D to reload Z index.")
    return

  for obj in objects:
    reload_object_zindex(obj)

  print("Reloaded Z index for all objects in the grid layer.")


func _get_z_index_at_position(cell_position: Vector2) -> int:
  var used_rect = get_used_rect()
  if not used_rect.has_point(cell_position):
    push_error("Position is out of bounds of the used rectangle.")
    return 0
  # set the z_index according to the position of x in the used rectangle
  var new_z_index = int((cell_position.x - used_rect.position.x) / used_rect.size.x * 100)
  print("Calculated Z index at cell_position ", cell_position, " is ", new_z_index)
  return new_z_index
