extends State
class_name EnemyChasing

@export var enemy: CharacterBody2D 

@onready var player = get_tree().get_first_node_in_group("player")
@onready var pathfindingcomp: PathfindingComponent = get_parent().pathfindingcomp

var move_direction: Vector2

func physics_update(_delta: float):
	pathfindingcomp.recalculate_path_to_player()
	var direction = pathfindingcomp.to_local(pathfindingcomp.nav_agent.get_next_path_position()).normalized()
	var distance = player.global_position - enemy.global_position
	
	#If ready to attack
	if distance.length() < 45: #attack range
		enemy.current_speed = 0
		#transition to attack component here
	
	#if player non visible2 
	elif pathfindingcomp.is_at_target():
		enemy.current_speed = 0
		transitioned.emit(self, "idle")
	else: 
		enemy.current_speed = enemy.max_speed
		move_direction = direction
