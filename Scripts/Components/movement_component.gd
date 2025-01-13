extends Node2D

# Movement properties
@export var speed: float = 200.0
var velocity: Vector2 = Vector2.ZERO

func _process(delta):
	if velocity.length() > 0:
		position += velocity.normalized() * speed * delta

func set_velocity(new_velocity: Vector2):
	velocity = new_velocity
