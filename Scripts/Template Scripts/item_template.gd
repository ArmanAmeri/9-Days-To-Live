extends RigidBody2D

@export var item_name: String = "item"
@export var amount: int = 1

@onready var interaction_area: InteractionAreaComponent = $InteractionAreaComponent
@onready var player = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	

func _on_interact():
	player.inventoryAction("add_item", item_name, amount)
	self.queue_free()
