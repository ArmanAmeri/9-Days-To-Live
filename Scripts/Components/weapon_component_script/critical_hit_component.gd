class_name CriticalHitComponent
extends Node2D

@onready var attack_handler: AttackHandler = $"../AttackHandler"

@export var crit_chance: float = 0.15
@export var crit_multiplier: float = 1.5

func _ready() -> void:
	attack_handler.attack_performed.connect(_on_attack_performed)

func _on_attack_performed(base_damage: float) -> void:
	if randf() < crit_chance:
		attack_handler.attack_performed.emit(base_damage * crit_multiplier)
