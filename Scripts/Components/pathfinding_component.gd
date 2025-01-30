extends Node2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var ray_cast: RayCast2D = $RayCast2D
@onready var recalculation_timer: Timer = $RecalculationTimer

var player_visible: bool = false
var last_seen_position: Vector2 = Vector2.ZERO  # Last known player position
var stopping_distance: float = 5.0  # Distance threshold to stop at the target
var reached_last_position: bool = true  # Whether the enemy reached the last seen position

signal move_input(direction: Vector2)

func _ready() -> void:
	recalculation_timer.start()

func _physics_process(_delta: float) -> void:
	# RayCast2D always looks at the player
	ray_cast.look_at(player.global_position)

	# Check player visibility with RayCast2D
	player_visible = is_player_visible()

	# Stop moving if the enemy has reached the last known position
	if nav_agent.is_navigation_finished() and is_at_target():
		reached_last_position = true
		return

	# Handle movement if not at the target
	if not reached_last_position:
		var direction = to_local(nav_agent.get_next_path_position()).normalized()
		move_input.emit(direction)
	elif player_visible == false: move_input.emit(Vector2(0, 0))

# RayCast2D visibility logic
func is_player_visible() -> bool:
	if ray_cast.is_colliding():
		var collider = ray_cast.get_collider()
		return collider is Player or collider is HitboxComponent
	return false

# Recalculate path based on visibility
func recalculate_path() -> void:
	if player_visible and player:
		# If player is visible, set the target position to the player's current position
		nav_agent.target_position = player.global_position
		last_seen_position = player.global_position
		reached_last_position = false
	elif not player_visible and not reached_last_position:
		# If player is not visible, navigate to the last known position
		nav_agent.target_position = last_seen_position

# Timer for performance optimization
func _on_recalculation_timer_timeout() -> void:
	if not is_at_target():  # Only recalculate if not at the target
		recalculate_path()

# Check if the enemy has reached its destination
func is_at_target() -> bool:
	return global_position.distance_to(nav_agent.target_position) <= stopping_distance
