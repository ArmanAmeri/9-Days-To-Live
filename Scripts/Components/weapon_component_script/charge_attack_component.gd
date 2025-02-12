class_name ChargeAttackComponent
extends Node2D

@onready var attack_handler: AttackHandler = $"../AttackHandler"
@onready var durability: DurabilityComponent = $"../Durability"

@export var charge_multiplier: float = 2.0
@export var charge_durability_cost: float = 4.0

var is_charging: bool = false

func start_charge() -> void:
	is_charging = true

func _ready() -> void:
	attack_handler.attack_performed.connect(_on_attack_performed)

func _on_attack_performed(base_damage: float) -> void:
	if is_charging:
		attack_handler.attack_performed.emit(base_damage * charge_multiplier)
		durability.reduce_durability(charge_durability_cost)
		is_charging = false
