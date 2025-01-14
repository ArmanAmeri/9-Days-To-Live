extends CharacterBody2D


@onready var movement_component = $MovementComponent
@onready var input_component = $InputComponent

func _ready() -> void:
	input_component.connect("move_input", _on_move_input)

func _on_move_input(direction: Vector2) -> void:
	movement_component.set_velocity(direction)
