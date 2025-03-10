extends Node2D
signal move_input(direction: Vector2, dashing: bool, dash_direction: Vector2)

@onready var inventory: Node2D = $"../InventoryComponent"
@onready var dash_timer: Timer = $"../Timers/DashTimer"
var dashing: bool = false
var stored_dash_direction = Vector2.ZERO

func _ready() -> void:
	dash_timer.connect("timeout", on_dash_timer_timeout)

func _process(_delta: float) -> void:
	var direction = Vector2.ZERO
	var dash_direction = Vector2.ZERO
	
	if Input.is_action_pressed("d"):
		direction.x += 1
	if Input.is_action_pressed("a"):
		direction.x -= 1
	if Input.is_action_pressed("s"):
		direction.y += 1
	if Input.is_action_pressed("w"):
		direction.y -= 1
	
	if Input.is_action_just_pressed("dash") and not dashing:
		dashing = true
		stored_dash_direction = direction.normalized()
		dash_direction = stored_dash_direction
	elif dashing:
		dash_direction = stored_dash_direction
	
	move_input.emit(direction, dashing, dash_direction)

func on_dash_timer_timeout() -> void:
	dashing = false
	stored_dash_direction = Vector2.ZERO
