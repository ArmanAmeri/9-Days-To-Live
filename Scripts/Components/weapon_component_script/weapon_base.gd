# weapon.gd
class_name Weapon
extends Node2D

@export var id_name: String
@export var attack_data: AttackData

@onready var weapon_type: String = itemLibrary.get_item_info(id_name, "weapon_type")
@onready var attack_handler: AttackHandler = $AttackHandler
@onready var durability: DurabilityComponent = $DurabilityComponent

func _ready() -> void:
	attack_data.base_damage = itemLibrary.get_item_info(id_name, "damage")


func attack() -> void:
	if attack_handler and durability.has_durability():
		attack_handler.perform_attack()
		
