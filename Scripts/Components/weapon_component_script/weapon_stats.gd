class_name WeaponStats
extends Node2D

var attack = Attack.new()
var weapon_name: String = get_parent().weapon_name


@export var base_attack: AttackData
var durability: float
var damage: float = itemLibrary.get_item_info(weapon_name, "damage")
var attack_speed: float = itemLibrary.get_item_info(weapon_name, "attack_speed")
var attack_range: float = itemLibrary.get_item_info(weapon_name, "range")
var weight: float = itemLibrary.get_item_info(weapon_name, "weight")
