extends Node2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var ray_cast: RayCast2D = $RayCast2D

signal move_input(direction: Vector2)

func _ready() -> void:
	call_deferred("enemy_setup")

func enemy_setup():
	await get_tree().physics_frame
	if player:
		navigation_agent.target_position = player.global_position
		ray_cast.look_at(player.global_position)

func _physics_process(_delta: float) -> void:
	enemy_setup()
	if ray_cast.is_colliding() and (ray_cast.get_collider() is HitboxComponent or ray_cast.get_collider() is Player):
		if navigation_agent.is_navigation_finished():
			return
		var current_agent_position = global_position
		var next_path_position = navigation_agent.get_next_path_position()
		move_input.emit(current_agent_position.direction_to(next_path_position))
	else: move_input.emit(Vector2(0, 0))
