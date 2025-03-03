class_name HitboxComponent
extends Area2D

@export var health_component: HealthComponent
@export var hit_flash_component: Node2D

# Make hitbox component able to handle status effects
var active_status_effects: Array[StatusEffect] = []

func _ready() -> void:
	# Make sure this hitbox can be targeted by attacks
	add_to_group("damageable")

func take_damage(damage_amount: float, damage_type: int = AttackData.DamageType.SLASHING) -> void:
	if health_component:
		health_component.take_damage(damage_amount, damage_type)
		
	# Flash the entity if hit_flash_component exists and has the method
	if hit_flash_component and hit_flash_component.has_method("flash"):
		hit_flash_component.flash()

func apply_knockback(knockback_vector: Vector2) -> void:
	# Forward knockback to parent if it has the method
	if get_parent().has_method("apply_knockback"):
		get_parent().apply_knockback(knockback_vector)

func apply_status_effect(effect: StatusEffect) -> void:
	# Add status effect to the active effects
	active_status_effects.append(effect)
	
	# Create a timer to handle the effect duration
	var timer = Timer.new()
	timer.wait_time = effect.duration
	timer.one_shot = true
	add_child(timer)
	
	# Connect the timer to remove the effect when it expires
	timer.timeout.connect(func(): _remove_status_effect(effect, timer))
	timer.start()
	
	# If the effect deals damage over time, set up ticking damage
	if effect.tick_damage > 0 and effect.tick_rate > 0:
		_setup_damage_ticks(effect)

func _setup_damage_ticks(effect: StatusEffect) -> void:
	var tick_timer = Timer.new()
	tick_timer.name = "TickTimer_" + str(active_status_effects.size())
	tick_timer.wait_time = effect.tick_rate
	add_child(tick_timer)
	
	tick_timer.timeout.connect(func(): _apply_tick_damage(effect, tick_timer))
	tick_timer.start()

func _apply_tick_damage(effect: StatusEffect, timer: Timer) -> void:
	if health_component and active_status_effects.has(effect):
		# Apply the tick damage
		health_component.take_damage(effect.tick_damage, _status_to_damage_type(effect.effect_type))
		
		# Restart the timer for the next tick if the effect is still active
		if active_status_effects.has(effect):
			timer.start()

func _remove_status_effect(effect: StatusEffect, timer: Timer) -> void:
	active_status_effects.erase(effect)
	timer.queue_free()
	
	# Find and remove any associated tick timers
	var tick_timers = get_children().filter(func(node): 
		return node is Timer and node.name.begins_with("TickTimer_")
	)
	for tick_timer in tick_timers:
		tick_timer.queue_free()

func _status_to_damage_type(effect_type: int) -> int:
	match effect_type:
		StatusEffect.EffectType.BURN:
			return AttackData.DamageType.MAGIC
		StatusEffect.EffectType.POISON:
			return AttackData.DamageType.MAGIC
		StatusEffect.EffectType.BLEED:
			return AttackData.DamageType.SLASHING
		_:
			return AttackData.DamageType.MAGIC

func has_status_effect(effect_type: int) -> bool:
	for effect in active_status_effects:
		if effect.effect_type == effect_type:
			return true
	return false
