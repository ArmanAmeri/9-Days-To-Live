extends State
class_name EnemyIdle

signal move_input(direction: Vector2)

var wander_time: float

func physics_update(delta: float):
	move_input.emit(Vector2(0, 0))

func randomize_time_between_wander():
	wander_time = randf_range(1, 3)

func update(delta: float):
	if wander_time > 0:
		wander_time -= delta
	else: transitioned.emit(self, "patrolling")
