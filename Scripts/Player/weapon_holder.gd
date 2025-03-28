extends Node2D


@onready var holding_type: String
var current_weapon: Weapon

func equip_weapon(weapon_scene: PackedScene) -> void:
	if current_weapon:
		current_weapon.queue_free()
	
	current_weapon = weapon_scene.instantiate() as Weapon
	self.add_child(current_weapon)
	PlayerInfo.weapon_type = current_weapon.weapon_type

func attack() -> void:
	if current_weapon:
		current_weapon.attack()

func get_current_weapon() -> Weapon:
	return current_weapon

func update_sprite() -> void:
	pass
