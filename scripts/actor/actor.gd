class_name Actor
extends CharacterBody2D

@export var movement_component: MovementComponent

@export var speed: float = 2.0


func _ready() -> void:
  # Initialize the actor's movement component
  if movement_component:
    movement_component.actor = self
  else:
    push_error("Actor requires a MovementComponent to function properly.")
