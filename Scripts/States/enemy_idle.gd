extends State
class_name EnemyIdle

signal move_input(direction: Vector2)

@onready var character_body = get_parent().get_parent() as CharacterBody2D
@onready var pathfindingcomp: PathfindingComponent = get_parent().pathfindingcomp

var wander_time: float
var move_direction: Vector2

func enter():
	character_body.current_speed = 0
	randomize_time_between_wander()

func exit():
	character_body.current_speed = character_body.max_speed

func randomize_time_between_wander():
	wander_time = randf_range(1, 6)

func update(delta: float):
	if pathfindingcomp.is_player_visible():
		transitioned.emit(self, "chasing")
	elif wander_time > 0:
		wander_time -= delta
	else: transitioned.emit(self, "patrolling")
