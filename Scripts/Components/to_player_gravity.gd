extends Area2D

@export var speed: float = 100.0  # Speed at which the parent moves towards the player
@export var max_multiplier: int = 100  # Maximum multiplier when the parent is closest to the player
@export var min_multiplier: int = 1   # Minimum multiplier when the parent is farthest from the player
@export var max_distance: float = 100.0  # Distance at which the multiplier is at its minimum

@onready var timer: Timer = $Timer


var player_entered: bool = false
var player: CharacterBody2D = null
var just_spawned: bool = true

func _ready():
	timer.start()
	# Connect signals to detect when the player enters or exits the area
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body: Node):
	if body.is_in_group("player"):  # Ensure the body is the player
		player_entered = true
		player = body  # Store the player reference

func _on_body_exited(body: Node):
	if body.is_in_group("player"):
		player_entered = false
		player = null  # Clear the player reference

func _physics_process(delta: float):
	if not just_spawned:
		if player_entered and player:
			var parent = get_parent() as CharacterBody2D
			if parent:
				# Calculate the direction to the player
				var direction = (player.global_position - parent.global_position).normalized()
				
				# Calculate the distance between the parent and the player
				var distance = parent.global_position.distance_to(player.global_position)
				
				# Calculate the multiplier based on the distance
				var multiplier = lerp(max_multiplier, min_multiplier, distance / max_distance)
				
				# Set the parent's velocity to move towards the player with the dynamic multiplier
				parent.velocity = direction * speed * delta * multiplier


func _on_timer_timeout() -> void:
	just_spawned = false
