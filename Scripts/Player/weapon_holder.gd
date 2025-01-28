extends Node2D


@onready var holding_type: String

func _process(_delta: float) -> void:
	var child_node = get_children()
	if child_node:
		holding_type = child_node[0].type
		print("Child variable value: ", holding_type)
	else:
		print("Child node not found!")
