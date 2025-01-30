extends Node2D

signal move_input(direction: Vector2, dashing: bool)

@onready var inventory: Node2D = $"../InventoryComponent"
@onready var dash_timer: Timer = $"../Timers/DashTimer"


func _process(_delta: float) -> void:
	var direction = Vector2.ZERO
	var dashing: bool = false
	if Input.is_action_pressed("d"):
		direction.x += 1
	if Input.is_action_pressed("a"):
		direction.x -= 1
	if Input.is_action_pressed("s"):
		direction.y += 1
	if Input.is_action_pressed("w"):
		direction.y -= 1
		
	if Input.is_action_just_pressed("dash"):
		dashing = true

	
	move_input.emit(direction, dashing)
