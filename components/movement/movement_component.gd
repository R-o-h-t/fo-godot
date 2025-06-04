class_name MovementComponent
extends Node

@export var actor: Actor

var grid: MoveGrid

func _ready() -> void:
    if not actor:
        push_error("MovementComponent requires an Actor to function.")
        return

func request_move_to(target_position: Vector2) -> void:
    # Request the actor to move to a new position
    if not actor:
        push_error("MovementComponent requires an Actor to function.")
        return

    if actor.position != target_position:
        if grid:
            # Check if the target position is within the grid bounds and not occupied
            if not grid.get_cell_is_in_bounds(target_position) or \
               grid.get_cell_is_occupied(target_position) or \
               not grid.get_cell_has_ground(target_position):
                push_error("Target position is out of bounds, occupied, or has no ground.")
                return

        actor.position = grid.active_layer.map_to_local(target_position) if grid else target_position
        grid.active_layer.reload_object_zindex(actor)
        print("Requested move to position: ", target_position)

    else:
        print("Actor is already at the target position: ", target_position)
