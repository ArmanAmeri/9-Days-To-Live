extends CharacterBody2D

class_name Player

@onready var movement_component = $MovementComponent
@onready var input_component = $InputComponent
@onready var inventory = $InventoryComponent

func _ready() -> void:
	input_component.connect("move_input", _on_move_input)

func _on_move_input(direction: Vector2) -> void:
	movement_component.set_velocity(direction)
	

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
		
