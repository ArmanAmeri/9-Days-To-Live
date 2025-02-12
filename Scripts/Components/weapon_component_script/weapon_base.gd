# weapon.gd
class_name Weapon
extends Node2D


@export var detection_shape: CollisionShape2D
@export var durability_max: float = 100.0
@export var attack_data: AttackData


@onready var attack_handler: AttackHandler = $AttackHandler
@onready var durability: DurabilityComponent = $DurabilityComponent


func _ready() -> void:
	$AttackArea.make_circle(30.0)  # For an AoE weapon

func attack() -> void:
	if attack_handler and durability.has_durability():
		attack_handler.perform_attack()
