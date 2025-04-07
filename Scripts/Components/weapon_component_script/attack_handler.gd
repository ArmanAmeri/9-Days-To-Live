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
	# Check if timer already exists
	attack_timer = get_node_or_null("AttackTimer")
	
	# Only create a new timer if one doesn't exist
	if not attack_timer:
		attack_timer = Timer.new()
		attack_timer.name = "AttackTimer"
		attack_timer.one_shot = true
		add_child(attack_timer)
	
	# Connect the signal regardless
	if not attack_timer.timeout.is_connected(_on_attack_timer_timeout):
		attack_timer.timeout.connect(_on_attack_timer_timeout)

func perform_attack(facing_dir:String) -> void:
	if not can_attack:
		return
	
	can_attack = false
	attack_timer.start(1.0 / attack_data.attack_speed)
	
	# After trying thing around, i think it should be a vector faceing_dir and also a rotation on where the attack will be at.
	if anim_player:
		if facing_dir == "N":
			anim_player.play("N")
		elif facing_dir == "S":
			anim_player.play("S")
		elif facing_dir == "E":
			anim_player.play("E")
		elif facing_dir == "W":
			anim_player.play("W")
	
	
	var targets = _get_targets_in_range()
	for target in targets:
		attack_data.apply_to_target(target, global_position)
	
	attack_performed.emit(attack_data)

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
