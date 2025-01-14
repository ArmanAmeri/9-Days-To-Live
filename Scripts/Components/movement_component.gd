extends Node2D

# Export variables for movement properties
@export var speed: float = 200.0

# Internal velocity vector
var velocity: Vector2 = Vector2.ZERO

# Reference to the parent CharacterBody2D
@onready var character_body = get_parent() as CharacterBody2D

func _physics_process(delta: float) -> void:
	if character_body:
		if velocity != Vector2.ZERO:
			character_body.velocity = velocity.normalized() * speed
			character_body.move_and_slide()
		else:
			character_body.velocity = Vector2.ZERO
	if not character_body:
		return # Ensure this component is attached to a CharacterBody2D
	

func set_velocity(direction: Vector2) -> void:
	velocity = direction
