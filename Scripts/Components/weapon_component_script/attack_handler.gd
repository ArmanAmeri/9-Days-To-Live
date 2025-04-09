# attack_handler.gd
class_name AttackHandler
extends Node2D

signal attack_performed(attack: AttackData)
signal attack_finished

@onready var attack_area: AttackArea = $"../AttackArea"
@onready var attack_data: AttackData = get_parent().attack_data if get_parent() is Weapon else null
@onready var anim_player: AnimationPlayer = $"../AnimationPlayer"

var can_attack: bool = true
var attack_timer: Timer

func _ready() -> void:
	# Remove existing timer if any
	var existing_timer = get_node_or_null("AttackTimer")
	if existing_timer:
		existing_timer.queue_free()
	
	# Create a new timer
	attack_timer = Timer.new()
	attack_timer.name = "AttackTimer"
	attack_timer.one_shot = true
	add_child(attack_timer)
	
	# Connect with explicit reference to self
	attack_timer.timeout.connect(self._on_attack_timer_timeout)
	
	print("Timer setup complete")

func perform_attack() -> void:
	if not can_attack:
		return
	
	can_attack = false
	attack_timer.start(1.0 / attack_data.attack_speed)
	
	if anim_player:
		# Connect to the animation_finished signal
		if not anim_player.animation_finished.is_connected(self._on_animation_finished):
			anim_player.animation_finished.connect(self._on_animation_finished)
		
		anim_player.play("Slash")
		attack_area.look_at(PlayerInfo.cursor_target)
		attack_area.rotation -= PI / 2
	
	var targets = _get_targets_in_range()
	for target in targets:
		attack_data.apply_to_target(target, global_position)
	
	attack_performed.emit(attack_data)

# Add this new method to handle animation completion
func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "Slash":
		# Reset to the first frame or default state
		anim_player.stop()  # This stops the animation and returns to default state
		# Or alternatively, you can seek to the beginning:
		# anim_player.seek(0, true)

func _get_targets_in_range() -> Array[Node2D]:
	var targets: Array[Node2D] = []
	var bodies = attack_area.get_overlapping_bodies()
	
	for body in bodies:
		if _is_valid_target(body):
			targets.append(body)
	
	return targets

func _is_valid_target(body: Node) -> bool:
	return body.is_in_group("damageable") and body != owner

func _on_attack_timer_timeout() -> void:
	can_attack = true
	attack_finished.emit()
