extends Node2D

class_name HealthComponent

# Signal emitted when health changes
signal health_changed(current_health, max_health)
signal died()

# Health properties
@export var max_health: int = 100
var current_health: int

func _ready():
	current_health = max_health

func take_damage(attack: Attack):
	current_health -= attack.attack_damage
	health_changed.emit(current_health, max_health)
	if current_health <= 0:
		current_health = 0
		died.emit()

func heal(amount: int):
	current_health += amount
	if current_health > max_health:
		current_health = max_health
	health_changed.emit(current_health, max_health)
