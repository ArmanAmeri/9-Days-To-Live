class_name HealthComponent
extends Node2D

# Signals
signal health_changed(current_health, max_health)
signal damage_taken(amount, type)
signal died()

# Health properties
@export var max_health: int = 100
@export var armor_values: Dictionary = {
	AttackData.DamageType.SLASHING: 0,
	AttackData.DamageType.PIERCING: 0,
	AttackData.DamageType.BLUDGEONING: 0,
	AttackData.DamageType.MAGIC: 0
}

var current_health: int
var is_invulnerable: bool = false

func _ready() -> void:
	current_health = max_health

# New method that handles damage from AttackData
func take_damage(damage_amount: float, damage_type: int = AttackData.DamageType.SLASHING) -> void:
	if is_invulnerable:
		return
		
	# Calculate damage reduction from armor
	var armor_value = armor_values.get(damage_type, 0)
	var reduced_damage = max(1, damage_amount - armor_value)
	
	# Apply damage
	current_health -= reduced_damage
	
	# Emit signals
	health_changed.emit(current_health, max_health)
	damage_taken.emit(reduced_damage, damage_type)
	
	# Check for death
	if current_health <= 0:
		current_health = 0
		died.emit()

# For backward compatibility with old Attack class
func damage(attack: Attack) -> void:
	take_damage(attack.damage)

func heal(amount: int) -> void:
	current_health += amount
	if current_health > max_health:
		current_health = max_health
	health_changed.emit(current_health, max_health)

func set_invulnerable(value: bool) -> void:
	is_invulnerable = value

func is_alive() -> bool:
	return current_health > 0

# Method to get current health percentage (0.0 to 1.0)
func get_health_percent() -> float:
	return float(current_health) / max_health
