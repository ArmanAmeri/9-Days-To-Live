# weapon.gd
class_name Weapon
extends Node2D

@export var id_name: String
@export var weapon_type: String = itemLibrary.get_item_info(id_name, "weapon_type")
@export var durability_max: float = 100.0
@export var attack_data: AttackData

@onready var attack_handler: AttackHandler = $AttackHandler
@onready var durability: DurabilityComponent = $DurabilityComponent
@onready var facing_dir: String

func _ready() -> void:
	attack_data.base_damage = itemLibrary.get_item_info(id_name, "damage")


func attack() -> void:
	facing_dir = PlayerInfo.facing_dir
	if attack_handler and durability.has_durability():
		attack_handler.perform_attack(facing_dir)
