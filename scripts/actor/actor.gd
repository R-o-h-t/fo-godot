class_name Actor
extends CharacterBody2D

@export var movement_component: MovementComponent

@export var speed: float = 2.0

func _ready() -> void:
  # Initialize the actor's movement component
  if movement_component:
    movement_component.actor = self
    movement_component._ready()
  else:
    push_error("MovementComponent is not assigned to the Actor.")
