extends CharacterBody2D

class_name Player

@onready var movement_component = $MovementComponent
@onready var input_component = $InputComponent
@onready var inventory = $InventoryComponent
@onready var dash_timer: Timer = $Timers/DashTimer
@onready var dash_cooldown: Timer = $Timers/DashCooldown


var can_dash: bool = true
var speed: float = 100
var orgspeed: float = 100

func _ready() -> void:
	input_component.connect("move_input", _on_move_input)
	dash_timer.connect("timeout", _dash_stop)
	dash_cooldown.connect("timeout", _dash_cooldown)

func _on_move_input(direction: Vector2, dashing: bool) -> void:
	movement_component.set_velocity(direction)
	if dashing and can_dash:
		dash_timer.start()
		speed += (speed/100)*300#%
		can_dash = false
		dash_cooldown.start()


func inventoryAction(action: String, itemName: String, amount: int):
	var item
	if action == "add_item":
		item = itemLibrary.get_item_info(itemName, "none")
		inventory.add_item(item)
		inventory.print_inventory()
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
		

func _dash_stop() -> void:
	speed = orgspeed

func _dash_cooldown() -> void:
	can_dash = true
