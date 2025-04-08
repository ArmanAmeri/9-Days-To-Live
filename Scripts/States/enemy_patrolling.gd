extends State
class_name EnemyPatrolling

#BUG: random pos can be a wall, thus making the enemy go in to a wall. Can be fixed by checking tilemap layer
#BUG: its fucked rn


@export var enemy: CharacterBody2D
@export var movement_speed := 10.0
@export var max_distance_from_spawn: float
@export var minimum_wander_time: int = 1 #default values
@export var maximum_wander_time: int = 3

@onready var pathfindingcomp: PathfindingComponent = get_parent().pathfindingcomp
@onready var loscomp: LOSComponent = get_parent().los_component
@onready var marker: Line2D = $"../../Line2D"

var move_direction: Vector2
var move_position: Vector2
var wander_time: float
var spawn_position: Vector2

func _ready() -> void:
	spawn_position = enemy.position

func randomize_wander():
	move_position = Vector2(randf_range(spawn_position.x - max_distance_from_spawn, spawn_position.x + max_distance_from_spawn), randf_range(spawn_position.y - max_distance_from_spawn, spawn_position.y + max_distance_from_spawn))
	pathfindingcomp.recalculate_path(move_position)
	marker.global_position = move_position
	marker.set_as_top_level(true)
	print("Current enemy dir", move_direction)
	wander_time = randf_range(minimum_wander_time, maximum_wander_time)

func enter():
	randomize_wander()

func physics_update(_delta: float):
	var direction = pathfindingcomp.movement_direction
	
	#if player non visible2 
	if pathfindingcomp.is_at_target():
		enemy.current_speed = 0
		transitioned.emit(self, "idle")
	else: 
		enemy.current_speed = enemy.max_speed
		move_direction = direction
	print(move_direction)


func update(delta: float):
	if loscomp.check_ray_collisions(loscomp.ray_list):
		transitioned.emit(self, "chasing")
	elif wander_time > 0:
		wander_time -= delta
	else: transitioned.emit(self, "idle")
