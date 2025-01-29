extends Node2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var ray_cast: RayCast2D = $RayCast2D
@onready var recalculation_timer: Timer = $RecalculationTimer

var player_visible: bool = true
var last_seen_position: Vector2

signal move_input(direction: Vector2)

func _ready() -> void:
	recalculation_timer.start()


func _physics_process(_delta: float) -> void:
	ray_cast.look_at(player.global_position)
	if nav_agent.is_navigation_finished():
		return
	var direction = to_local(nav_agent.get_next_path_position()).normalized()
	if ray_cast.is_colliding():
		if ray_cast.get_collider() is Player or ray_cast.get_collider() is HitboxComponent:
			player_visible = true
			last_seen_position = player.global_position
			move_input.emit(direction)
		else:
			player_visible = false

			

func recalculate_path():
	if player_visible and player:
		# If the player is visible, set the target position to the player's current position
		nav_agent.target_position = player.global_position
	elif not player_visible:
		# If the player is not visible, navigate to the last seen position
		nav_agent.target_position = last_seen_position

#Timer for performance	
func _on_recalculation_timer_timeout() -> void:
	recalculate_path()
