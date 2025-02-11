class_name MeleeAttackComponent
extends Node2D

@onready var attack_handler: AttackHandler = $"../AttackHandler"
@onready var durability: DurabilityComponent = $"../Durability"

@export var durability_cost: float = 1.0
@export var damage_multiplier: float = 1.0

func _ready() -> void:
	attack_handler.attack_performed.connect(_on_attack_performed)

func _on_attack_performed(base_damage: float) -> void:
	durability.reduce_durability(durability_cost)
