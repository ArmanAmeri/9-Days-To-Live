extends CharacterBody2D

@export var id: String = "xp"
@export var velocity_loss: int = 4

@onready var sprite_texture = itemLibrary.get_item_info(id, "image")
@onready var amount: int = itemLibrary.get_item_info(id, "amount")
@onready var player = get_tree().get_first_node_in_group("player")


func _physics_process(delta: float) -> void:
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())
	velocity -= velocity * delta * velocity_loss


func xp_gained():
	self.queue_free()
