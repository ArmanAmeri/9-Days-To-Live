class_name StatusEffect
extends Resource

enum EffectType {
	POISON,
	BURN,
	BLEED,
	STUN,
	SLOW
}

@export var effect_type: EffectType
@export var duration: float
@export var tick_damage: float
@export var tick_rate: float
@export var potency: float  # For effects like slow (percentage)
