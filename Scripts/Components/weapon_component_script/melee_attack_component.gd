class_name MeleeAttackComponent
extends Node2D

@onready var attack_handler: AttackHandler = $"../AttackHandler"
@onready var durability: DurabilityComponent = $"../DurabilityComponent"

@export var durability_cost: float = 1.0
@export var damage_multiplier: float = 1.0

func _ready() -> void:
	attack_handler.attack_performed.connect(_on_attack_performed)

func _on_attack_performed(_attack_data: AttackData) -> void:
	durability.reduce_durability(durability_cost)
