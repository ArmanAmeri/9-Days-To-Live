extends State
class_name EnemyIdle

@onready var character_body = get_parent().get_parent() as CharacterBody2D
@onready var pathfindingcomp: PathfindingComponent = get_parent().pathfindingcomp
@onready var loscomp: LOSComponent = get_parent().los_component


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
	if loscomp.check_ray_collisions(loscomp.ray_list):
		transitioned.emit(self, "chasing")
	elif wander_time > 0:
		wander_time -= delta
	else: transitioned.emit(self, "patrolling")
