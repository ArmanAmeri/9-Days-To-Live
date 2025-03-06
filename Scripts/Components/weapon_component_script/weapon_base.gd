# weapon.gd
class_name Weapon
extends Node2D

@export var id_name: String
@export var durability_max: float = 100.0
@export var attack_data: AttackData

func _ready() -> void:
	attack_data.base_damage = itemLibrary.get_item_info(id_name, "damage")

@onready var attack_handler: AttackHandler = $AttackHandler
@onready var durability: DurabilityComponent = $DurabilityComponent


func attack() -> void:
	if attack_handler and durability.has_durability():
		attack_handler.perform_attack()
