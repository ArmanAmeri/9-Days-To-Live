extends Node2D

# Signals
signal inventory_updated(item_list)

# Inventory settings
@export var max_slots: int = 20  # Maximum number of slots in the inventory
var inventory: Array = []  # Array to hold items (can be strings, dictionaries, or objects)

# Adds an item to the inventory
func add_item(item: Dictionary) -> bool:
	"""
	Add an item to the inventory. Returns true if successful, false if inventory is full.
	"""
	inventory.append(item)
	inventory_updated.emit(inventory)
	return true

# Removes an item from the inventory
func remove_item(item_name: String, amount: int = 1) -> bool:
	"""
	Remove an item by name. Returns true if successful, false if the item is not found.
	"""
	for i in range(inventory.size()):
		if inventory[i]["name"] == item_name:
			inventory[i]["amount"] -= amount
			if inventory[i]["amount"] <= 0:
				inventory.remove_at(i)  # Remove completely if amount <= 0
			inventory_updated.emit(inventory)
			return true
	return false  # Item not found

# Check if the inventory contains an item
func has_item(item_name: String) -> bool:
	"""
	Check if the inventory contains an item with the given name.
	"""
	for item in inventory:
		if item["name"] == item_name:
			return true
	return false

# Get the quantity of a specific item
func get_item_quantity(item_name: String) -> int:
	"""
	Get the quantity of an item. Returns 0 if the item is not found.
	"""
	for item in inventory:
		if item["name"] == item_name:
			return item["amount"]
	return 0

func print_inventory():
	print(inventory)

# Clear the inventory
func clear_inventory():
	inventory.clear()
	inventory_updated.emit(inventory)
