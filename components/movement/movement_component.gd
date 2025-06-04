class_name MovementComponent
extends Node

@export var actor: Actor

var movement_speed: float = 0.0 # current movement speed of the actor
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

    if movement_speed != 0:
        print("Actor already moving , call stop_movement() to stop current movement.")
        return

    if actor.position != target_position:
        if grid:
            # Check if the target position is within the grid bounds and not occupied
            if not grid.get_cell_is_in_bounds(target_position) or \
               grid.get_cell_is_occupied(target_position) or \
               not grid.get_cell_has_ground(target_position):
                push_error("Target position is out of bounds, occupied, or has no ground.")
                return

        actor.position = grid.map_to_local(target_position) if grid else target_position
        print("Requested move to position: ", target_position)

    else:
        print("Actor is already at the target position: ", target_position)

func request_move_by(offset: Vector2) -> void:
    # Request the actor to move by a certain offset
    if not actor:
        push_error("MovementComponent requires an Actor to function.")
        return

    var new_position = actor.position + offset
    if actor.position != new_position:
        actor.position = new_position
        print("Requested move by offset: ", offset, " New position: ", new_position)
    else:
        print("Actor is already at the new position after applying offset: ", new_position)


func stop_movement() -> void:
    # Stop the current movement of the actor
    if not actor:
        push_error("MovementComponent requires an Actor to function.")
        return
    if movement_speed == 0:
        print("Actor is not currently moving.")
        return
    movement_speed = 0.0
    print("Movement stopped for actor: ", actor.name)
