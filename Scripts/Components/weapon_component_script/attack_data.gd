# attack_data.gd
class_name AttackData
extends Resource

enum DamageType {
	SLASHING,
	PIERCING,
	BLUDGEONING,
	MAGIC
}

@export var base_damage: float
@export var damage_type: DamageType
@export var knockback_force: float
@export var status_effects: Array[StatusEffect]
@export var attack_speed: float

func apply_to_target(target: Node2D, attacker_position: Vector2) -> void:
	print("damage started")
	if target.has_method("take_damage"):
		target.take_damage(base_damage, damage_type)
		print("damage done")
	
	if target.has_method("apply_knockback"):
		var knockback_direction = (target.global_position - attacker_position).normalized()
		target.apply_knockback(knockback_direction * knockback_force)
	
	if target.has_method("apply_status_effect"):
		for effect in status_effects:
			target.apply_status_effect(effect)
