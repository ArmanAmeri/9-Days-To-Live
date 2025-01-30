extends CharacterBody2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var movement_component = $MovementComponent
@onready var pathfinding_component: Node2D = $PathfindingComponent


func _ready() -> void:
	pathfinding_component.connect("move_input", _on_move_input)

func _on_move_input(direction: Vector2) -> void:
	movement_component.set_velocity(direction)
