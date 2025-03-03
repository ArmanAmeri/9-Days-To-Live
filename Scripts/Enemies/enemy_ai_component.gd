extends Node2D
class_name IntegratedEnemyAI

# Attack system parameters
@export var attack_data: AttackData
@export var attack_area: AttackArea
@export var attack_cooldown: float = 1.0
@export var attack_range: float = 50.0

# Movement parameters
@export var move_speed: float = 100.0
@export var detection_range: float = 200.0
@export var stopping_distance: float = 5.0
@export var pursuit_interval: float = 0.5  # How often to update path during active pursuit

@onready var player = get_tree().get_first_node_in_group("player")
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var ray_cast: RayCast2D = $RayCast2D
@onready var recalculation_timer: Timer = $RecalculationTimer
@onready var pursuit_timer: Timer = $PursuitTimer

# State tracking variables
var attack_timer: Timer
var can_attack: bool = true
var player_visible: bool = false
var last_seen_position: Vector2 = Vector2.ZERO
var reached_last_position: bool = true
var is_pursuing_player: bool = false  # Flag to track active pursuit state

signal move_input(direction: Vector2)

func _ready() -> void:
	# Initialize attack timer
	attack_timer = Timer.new()
	attack_timer.name = "AttackTimer"
	attack_timer.one_shot = true
	add_child(attack_timer)
	
	# Initialize pursuit timer if it doesn't exist
	if not has_node("PursuitTimer"):
		pursuit_timer = Timer.new()
		pursuit_timer.name = "PursuitTimer"
		pursuit_timer.wait_time = pursuit_interval
		pursuit_timer.one_shot = false
		add_child(pursuit_timer)
	
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	pursuit_timer.timeout.connect(_on_pursuit_timer_timeout)
	recalculation_timer.start()

func _physics_process(_delta: float) -> void:
	if not player:
		return
	
	# Update player visibility
	ray_cast.global_position = global_position
	ray_cast.target_position = to_local(player.global_position)
	player_visible = is_player_visible()
	
	# Calculate distance to player
	var distance_to_player = global_position.distance_to(player.global_position)
	
	# Player detection logic
	if player_visible:
		# Start active pursuit when player is spotted
		if not is_pursuing_player:
			is_pursuing_player = true
			pursuit_timer.start()
			# Immediate path update when first spotting player
			update_path_to_player()
		
		# If in attack range, attack and stop moving
		if distance_to_player <= attack_range and can_attack:
			perform_attack()
			move_input.emit(Vector2.ZERO)
			return
	elif is_pursuing_player:
		# Player lost from sight, stop active pursuit but continue to last known position
		is_pursuing_player = false
		pursuit_timer.stop()
	
	# Handle movement logic
	if nav_agent.is_navigation_finished() or is_at_target():
		if is_at_target():
			reached_last_position = true
		move_input.emit(Vector2.ZERO)
		return
	
	# Move towards target if a valid path exists
	var next_path_position = nav_agent.get_next_path_position()
	var direction = global_position.direction_to(next_path_position)
	move_input.emit(direction * move_speed)

# Update the path to target the player
func update_path_to_player() -> void:
	if player and is_instance_valid(player):
		nav_agent.target_position = player.global_position
		last_seen_position = player.global_position
		reached_last_position = false

# Check if player is visible using raycast
func is_player_visible() -> bool:
	if ray_cast.is_colliding():
		var collider = ray_cast.get_collider()
		if collider is Player or collider.is_in_group("player") or collider is HitboxComponent:
			var distance = global_position.distance_to(player.global_position)
			return distance <= detection_range  # Only visible if within detection range
	return false

# Recalculate navigation path based on player visibility
func recalculate_path() -> void:
	if player_visible and player:
		# If player is visible, set the target position to the player's current position
		update_path_to_player()
	elif not player_visible and not reached_last_position:
		# If player is not visible, navigate to the last known position
		nav_agent.target_position = last_seen_position

# Continuous path updates during active pursuit
func _on_pursuit_timer_timeout() -> void:
	if is_pursuing_player and player_visible:
		update_path_to_player()

# Only recalculate path when needed (optimization)
func _on_recalculation_timer_timeout() -> void:
	if not is_at_target():
		recalculate_path()

# Check if enemy has reached target position
func is_at_target() -> bool:
	return global_position.distance_to(nav_agent.target_position) <= stopping_distance

# Handle attack execution
func perform_attack() -> void:
	if not can_attack or not attack_data or not attack_area:
		return
	
	can_attack = false
	attack_timer.start(attack_cooldown)
	
	# Enable attack area collision
	attack_area.collision_shape.disabled = false
	
	# Apply damage to targets in range
	var targets = get_targets_in_range()
	for target in targets:
		attack_data.apply_to_target(target, global_position)
	
	# Disable attack area after attack
	attack_area.collision_shape.disabled = true

# Get valid targets in attack range
func get_targets_in_range() -> Array:
	var targets = []
	var bodies = attack_area.get_overlapping_bodies()
	
	for body in bodies:
		if is_valid_target(body):
			targets.append(body)
	
	return targets

# Check if body is a valid attack target
func is_valid_target(body: Node) -> bool:
	return body.is_in_group("damageable") and body != owner

# Reset attack cooldown
func _on_attack_timer_timeout() -> void:
	can_attack = true
