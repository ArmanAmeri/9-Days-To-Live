extends Node2D

class_name inventorycomponent

# Signals
signal inventory_updated(item_list)

# Inventory settings
@export var max_slots: int = 20  # Maximum number of slots in the inventory
@export var max_stack_size: int = 99

var inventory: Array = []  # Array to hold items (can be strings, dictionaries, or objects)


func add_item(item: Dictionary) -> bool:
	print(inventory) # Debugging output
	for i in range(inventory.size()): # Iterate using an index
		var existing_item = inventory[i] # Access the dictionary
		if existing_item["ID"] == item["ID"] and item["stackable"]:
			# Check if we can fully stack the new item's amount
			var combined_amount = existing_item["amount"] + item["amount"]
			if combined_amount <= max_stack_size:
				inventory[i]["amount"] = combined_amount # Modify the dictionary directly
				inventory_updated.emit(inventory)
				return true
			else:
				# Calculate remaining space in the stack
				var remaining_space = max_stack_size - existing_item["amount"]
				if remaining_space > 0:
					inventory[i]["amount"] += remaining_space # Add to the existing stack
					item["amount"] -= remaining_space # Reduce the new item's amount
	# If there's still some of the item left, try adding it as a new stack
	if inventory.size() < max_slots and item["amount"] > 0:
		inventory.append(item.duplicate()) # Use .duplicate() to avoid modifying the original dictionary
		inventory_updated.emit(inventory)
		return true
	return false





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
