class_name DemoUI
extends Control

@export var toggle_turn_based_button: CheckButton
@export var end_turn_button: Button
@export var action_points_label: Label

@export var player: Actor


func _ready():
  if toggle_turn_based_button:
func toggle_turn_based_mode(toggle_mode: bool):
  if toggle_mode:
    end_turn_button.show()
    player.movement_component.set_movement_points(5)
  else:
    end_turn_button.hide()
    player.movement_component.set_movement_points(-1)
  toggle_turn_based_button.accept_event()

func end_turn():
  if toggle_turn_based_button.toggle_mode:
    player.movement_component.set_movement_points(5)
  else:
    print("Not in turn-based mode, cannot end turn.")
  end_turn_button.accept_event()
