extends Node2D

signal move_input(direction: Vector2)

@onready var inventory: Node2D = $"../InventoryComponent"


func _ready():
	var item_template_instance = load("res://Scenes/Items/potion.tscn").instantiate()
	item_template_instance.connect("item_area_entered", _on_item_area_entered)

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
	
	inventory.print_inventory()


func _on_item_area_entered():
	if Input.is_action_pressed("ui_select"):
		inventory.add_item({ "name": "Health Potion", "amount": 2 })
