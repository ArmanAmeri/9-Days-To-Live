extends Node2D

@onready var holding_type: String
var current_weapon: Weapon
var equiped_weapon: Weapon
var weapon = load("res://Scenes/Weapons/Sword/iron_sword.tscn")

func _ready() -> void:
	equip_weapon(weapon)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		attack()
	
func equip_weapon(weapon_scene: PackedScene) -> void:
	if current_weapon:
		current_weapon.queue_free()
	
	current_weapon = weapon_scene.instantiate() as Weapon
	self.add_child(current_weapon)
	equiped_weapon = self.get_child(0)
	PlayerInfo.weapon_type = current_weapon.weapon_type

func attack() -> void:
	if equiped_weapon == current_weapon:
		equiped_weapon.attack()

func get_current_weapon() -> Weapon:
	return current_weapon

func update_sprite() -> void:
	pass
