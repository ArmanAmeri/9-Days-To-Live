extends CharacterBody2D
class_name Enemy

@onready var player = get_tree().get_first_node_in_group("player")
@onready var movement_component = $MovementComponent
@onready var pathfinding_component: Node2D = $PathfindingComponent
@onready var meele_attack_ai_component: Area2D = $MeeleAttackAIComponent
@onready var enemy_patrolling: EnemyPatrolling = $StateMachine/Patrolling
@onready var state_machine: Node = $StateMachine
var dash_attack_cooldown: Timer

var max_speed = 50
var current_speed = max_speed

func _ready() -> void:
	dash_attack_cooldown = Timer.new()
	dash_attack_cooldown.wait_time = 0.5
	#pathfinding_component.connect("move_input", _on_move_input)
	enemy_patrolling.connect("move_input", _on_move_input)
	#meele_attack_ai_component.connect("meele_range_entered", _on_meele_range_entered)
	#meele_attack_ai_component.connect("meele_range_exited", _on_meele_range_exited)

func _on_move_input(direction: Vector2) -> void:
	movement_component.set_velocity(direction)
