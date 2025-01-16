extends CharacterBody2D

@onready var movement_component = $MovementComponent
@onready var ai_component: Node2D = $AIComponent

func _ready() -> void:
	ai_component.connect("move_input", _on_move_input)

func _on_move_input(direction: Vector2) -> void:
	movement_component.set_velocity(direction)
