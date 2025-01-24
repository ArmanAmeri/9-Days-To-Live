extends CharacterBody2D

@export var item_name: String = "item"
@export var amount: int = 1
@export var velocity_loss: int = 4

@onready var interaction_area: InteractionAreaComponent = $InteractionAreaComponent
@onready var player = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	

func _physics_process(delta: float) -> void:
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())
	velocity -= velocity * delta * velocity_loss

func _on_interact():
	player.inventoryAction("add_item", item_name, amount)
	self.queue_free()
