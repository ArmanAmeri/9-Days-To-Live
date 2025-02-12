class_name BlockComponent
extends Node2D

@export var block_value: float = 5.0
var is_blocking: bool = false

@onready var attack_handler: AttackHandler = $"../AttackHandler"
@onready var anim_player: AnimationPlayer = $"../AnimationPlayer"

func toggle_block() -> void:
	is_blocking = !is_blocking
	if anim_player:
		anim_player.play("block" if is_blocking else "unblock")

func get_block_value() -> float:
	return block_value if is_blocking else 0.0
