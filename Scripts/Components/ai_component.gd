extends Node2D

@onready var player = get_tree().get_first_node_in_group("player")


signal move_input(direction: Vector2)

func _process(_delta: float) -> void:
	var direction = (player.position - global_position).normalized()

	move_input.emit(direction)
