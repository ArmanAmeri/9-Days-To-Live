class_name RangedAttackComponent
extends Node2D

@onready var attack_handler: AttackHandler = $"../AttackHandler"
@onready var durability: DurabilityComponent = $"../Durability"

@export var max_ammo: int = 20
@export var durability_cost: float = 0.5

var current_ammo: int

func _ready() -> void:
	current_ammo = max_ammo
	attack_handler.attack_performed.connect(_on_attack_performed)

func _on_attack_performed(base_damage: float) -> void:
	if current_ammo > 0:
		current_ammo -= 1
		durability.reduce_durability(durability_cost)

func replenish_ammo(amount: int) -> void:
	current_ammo = mini(current_ammo + amount, max_ammo)
