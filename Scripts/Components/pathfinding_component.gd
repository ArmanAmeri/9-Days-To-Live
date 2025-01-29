extends Node2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var ray_cast: RayCast2D = $RayCast2D
@onready var recalculation_timer: Timer = $RecalculationTimer

var player_seen: bool = false

signal move_input(direction: Vector2)

func _ready() -> void:
	nav_agent.path_desired_distance = 4
	nav_agent.target_desired_distance = 4

func _physics_process(_delta: float) -> void:
	if nav_agent.is_navigation_finished():
		return
	
	var direction = to_local(nav_agent.get_next_path_position()).normalized()
	move_input.emit(direction)

func recalculate_path():
	if player:
		nav_agent.target_position = player.global_position

#Timer for performance
func _on_recalculation_timer_timeout() -> void:
	recalculate_path()
