extends State
class_name EnemyChasing

@export var enemy: CharacterBody2D
@export var pathfindingcomp: PathfindingComponent

@onready var player = get_tree().get_first_node_in_group("player")

var move_direction: Vector2

func physics_update(delta: float):
	var direction = pathfindingcomp.movement_direction
	var distance = player.global_position - enemy.global_position
	print(pathfindingcomp.movement_direction)
	print(enemy.current_speed)
	if distance.length() > 25: #and pathfindingcomp.reached_last_position != true:
		enemy.current_speed = enemy.max_speed
		move_direction = direction
	else: enemy.current_speed = 0 #actually transition to attack state here (MEELE ATTACK)
