extends Node2D

# Signal emitted when input is detected
signal movement_input(direction)

func _input(event):
	if event.is_action_pressed("ui_up"):
		emit_signal("movement_input", Vector2(0, -1))
	elif event.is_action_pressed("ui_down"):
		emit_signal("movement_input", Vector2(0, 1))
	elif event.is_action_pressed("ui_left"):
		emit_signal("movement_input", Vector2(-1, 0))
	elif event.is_action_pressed("ui_right"):
		emit_signal("movement_input", Vector2(1, 0))
