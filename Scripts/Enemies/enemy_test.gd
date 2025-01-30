extends CharacterBody2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var movement_component = $MovementComponent
@onready var pathfinding_component: Node2D = $PathfindingComponent
@onready var meele_attack_ai_component: Area2D = $MeeleAttackAIComponent
@onready var dash_attack_cooldown: Timer = $Timers/DashAttackCooldown


var speed = 50

func _ready() -> void:
	pathfinding_component.connect("move_input", _on_move_input)
	meele_attack_ai_component.connect("meele_range_entered", _on_meele_range_entered)
	meele_attack_ai_component.connect("meele_range_exited", _on_meele_range_exited)
	

func _on_move_input(direction: Vector2) -> void:
	movement_component.set_velocity(direction)

func _on_meele_range_entered():
	dash_attack_cooldown.start()

func _on_meele_range_exited():
	dash_attack_cooldown.stop()

func _on_dash_attack_cooldown_timeout() -> void:
	print("Meele attack!")
