extends State
class_name EnemyIdle

signal move_input(direction: Vector2)

@export var enemy: CharacterBody2D
@export var movement_speed := 10.0

var move_direction: Vector2
var wander_time: float


func randomize_wander():
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(1, 3)

func enter():
	randomize_wander()

func update(delta: float):
	if wander_time > 0:
		wander_time -= delta
	else: randomize_wander()

func physics_update(delta: float):
	if enemy:
		move_input.emit(move_direction)
