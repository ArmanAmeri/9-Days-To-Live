extends State
class_name EnemyPatrolling

#BUG: random pos can be a wall, thus making the enemy go in to a wall. Can be fixed by checking tilemap layer

@export var enemy: CharacterBody2D
@export var movement_speed := 10.0
@export var max_distance_from_spawn: float

@onready var pathfindingcomp: PathfindingComponent = get_parent().pathfindingcomp
@onready var marker: Line2D = $"../../Line2D"

var move_direction: Vector2
var move_position: Vector2
var wander_time: float
var spawn_position: Vector2

func _ready() -> void:
	spawn_position = enemy.position
	print("Enemys spawn position: ", spawn_position)

func randomize_wander():
	move_position = Vector2(randf_range(spawn_position.x - max_distance_from_spawn, spawn_position.x + max_distance_from_spawn), randf_range(spawn_position.y - max_distance_from_spawn, spawn_position.y + max_distance_from_spawn))
	
	marker.global_position = move_position
	marker.set_as_top_level(true)
	move_direction = enemy.position.direction_to(move_position)
	#print("Current enemy pos", enemy.position)
	wander_time = randf_range(1, 3)

func enter():
	randomize_wander()

func update(delta: float):
	if pathfindingcomp.is_player_visible():
		transitioned.emit(self, "chasing")
	elif wander_time > 0:
		wander_time -= delta
	else: transitioned.emit(self, "idle")
