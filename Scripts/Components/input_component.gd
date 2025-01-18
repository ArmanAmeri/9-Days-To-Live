extends Node2D

signal move_input(direction: Vector2)

@onready var inventory: Node2D = $"../InventoryComponent"



func _process(_delta: float) -> void:
	var direction = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1

	move_input.emit(direction)
	
