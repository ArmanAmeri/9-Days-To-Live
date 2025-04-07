extends CharacterBody2D

class_name Player

@onready var movement_component = $MovementComponent
@onready var input_component = $InputComponent
@onready var inventory = $InventoryComponent
@onready var dash_timer: Timer = $Timers/DashTimer
@onready var dash_cooldown: Timer = $Timers/DashCooldown

@onready var animation_tree: AnimationTree = $AnimationTree


var can_dash: bool = true
var current_speed: float = 120
var orgspeed: float = 120

var move_dir: Vector2 = Vector2.ZERO

func _ready() -> void:
	animation_tree.active = true
	
	input_component.connect("move_input", _on_move_input)
	dash_timer.connect("timeout", _dash_stop)
	dash_cooldown.connect("timeout", _dash_cooldown)

func _process(_delta: float) -> void:
	update_animation_parameters()

func _on_move_input(direction: Vector2, dashing: bool, dash_direction: Vector2) -> void:
	if dashing and can_dash:
		dash_timer.start()
		current_speed += (current_speed/100) * 400 #%
		can_dash = false
		dash_cooldown.start()
	elif input_component.dashing:
		movement_component.set_velocity(dash_direction)
	else:
		movement_component.set_velocity(direction)
		move_dir = direction


func inventoryAction(action: String, itemName: String, amount: int):
	var item
	if action == "add_item":
		item = itemLibrary.get_item_info(itemName, "none")
		inventory.add_item(item)
	elif action == "remove_item":
		item = itemLibrary.get_item_info(itemName, "none")
		inventory.remove_item(item, amount)
	elif action == "has_item":
		item = itemLibrary.get_item_info(itemName, "none")
		inventory.has_item(item)
	elif action == "get_item_quantity":
		item = itemLibrary.get_item_info(itemName, "none")
		inventory.get_item_quantity(item)
	elif action == "clear_inventory":
		inventory.clear_inventory()
	else:
		print("Invalid Inventory Action")
	
	inventory.print_inventory()

func update_animation_parameters():
	if velocity == Vector2.ZERO:
		animation_tree["parameters/conditions/is_idle"] = true
		animation_tree["parameters/conditions/is_running"] = false
	else:
		animation_tree["parameters/conditions/is_idle"] = false
		animation_tree["parameters/conditions/is_running"] = true
		
	if Input.is_action_just_pressed("attack"):
		animation_tree["parameters/conditions/is_attacking"] = true
	else:
		animation_tree["parameters/conditions/is_attacking"] = false
	
	if move_dir != Vector2.ZERO:
		animation_tree["parameters/Run/blend_position"] = move_dir
		animation_tree["parameters/Attack/blend_position"] = move_dir
		animation_tree["parameters/Idle/blend_position"] = move_dir
		
		if move_dir == Vector2(1, 0):
			PlayerInfo.facing_dir = "E"
		elif move_dir == Vector2(0, 1):
			PlayerInfo.facing_dir = "S"
		elif move_dir == Vector2(0, -1):
			PlayerInfo.facing_dir = "N"
		elif move_dir == Vector2(-1, 0):
			PlayerInfo.facing_dir = "W"

func _dash_stop() -> void:
	current_speed = orgspeed

func _dash_cooldown() -> void:
	can_dash = true
