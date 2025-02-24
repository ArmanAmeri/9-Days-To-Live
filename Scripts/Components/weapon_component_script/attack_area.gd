@tool
extends Area2D
class_name AttackArea

# Changed from @onready to regular variable
var collision_shape: CollisionShape2D
@onready var anim_player: AnimationPlayer = $"../AnimationPlayer"
@onready var attack_data: AttackData = get_parent().attack_data if get_parent() is Weapon else null

# Editor recording controls
@export_group("Recording Controls")
@export var recording_animation: String = "":
	set(value):
		recording_animation = value
		if Engine.is_editor_hint() and anim_player:
			anim_player.stop()
			current_time = 0.0
			frame_data.clear()
			_goto_time(0.0)
			print("Animation set to: ", value)

@export var time_between_frames: float = 0.1  # Seconds between frames

@export_group("Frame Navigation")
@export var current_time: float = 0.0:
	set(value):
		var old_time = current_time
		current_time = snappedf(value, 0.001)
		if Engine.is_editor_hint() and not recording_animation.is_empty() and old_time != current_time:
			_goto_time(current_time)

# Buttons for navigation
@export var next_frame: bool = false:
	set(value):
		if value and Engine.is_editor_hint():
			current_time += time_between_frames
		next_frame = false

@export var previous_frame: bool = false:
	set(value):
		if value and Engine.is_editor_hint():
			current_time = maxf(0.0, current_time - time_between_frames)
		previous_frame = false

# Recording controls
@export var record_frame: bool = false:
	set(value):
		if value and Engine.is_editor_hint():
			print("Attempting to record frame...")  # Debug print
			_record_frame()
		record_frame = false

@export var save_recording: bool = false:
	set(value):
		if value and Engine.is_editor_hint():
			_save_recording_to_animation()
		save_recording = false

signal hit_confirmed(target: Node2D)

var frame_data: Dictionary = {}

func _ready() -> void:
	# Find the collision shape
	for child in get_children():
		if child is CollisionShape2D:
			collision_shape = child
			print("Found collision shape: ", collision_shape.name)
			break
			
	if not collision_shape:
		print("WARNING: No CollisionShape2D found as child of AttackArea!")
	
	if not Engine.is_editor_hint():
		if collision_shape:
			collision_shape.disabled = true
		body_entered.connect(_on_body_entered)
	else:
		if anim_player:
			anim_player.stop()

func _enter_tree() -> void:
	# Also try to find collision shape when entering tree
	if not collision_shape:
		for child in get_children():
			if child is CollisionShape2D:
				collision_shape = child
				print("Found collision shape on enter tree: ", collision_shape.name)
				break

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("damageable") and body != owner:
		if attack_data:
			attack_data.apply_to_target(body, global_position)
		hit_confirmed.emit(body)

func _goto_time(time: float) -> void:
	if not anim_player or recording_animation.is_empty():
		return
		
	var animation = anim_player.get_animation(recording_animation)
	if animation and time <= animation.length:
		anim_player.stop()
		anim_player.seek(time, true)
		print("Moved to time: ", time, " seconds")

func _record_frame() -> void:
	print("Starting frame recording...")  # Debug print
	
	# Try to find collision shape again if we don't have it
	if not collision_shape:
		for child in get_children():
			if child is CollisionShape2D:
				collision_shape = child
				print("Found collision shape during recording: ", collision_shape.name)
				break
	
	if not collision_shape:
		print("No collision shape found! Children nodes: ", get_children())
		return
		
	if recording_animation.is_empty():
		print("No animation selected!")
		return
		
	var frame_info = {
		"disabled": collision_shape.disabled,
		"position": collision_shape.position,
		"scale": collision_shape.scale
	}
	
	# Record shape-specific data
	if collision_shape.shape is RectangleShape2D:
		frame_info["shape_size"] = collision_shape.shape.size
	elif collision_shape.shape is CircleShape2D:
		frame_info["radius"] = collision_shape.shape.radius
	
	frame_data[current_time] = frame_info
	print("Recorded frame at time: ", current_time, " seconds")
	
	# Move to next frame
	current_time += time_between_frames
	_goto_time(current_time)

func _save_recording_to_animation() -> void:
	if frame_data.is_empty():
		print("No recorded frames to save!")
		return
	
	var animation = anim_player.get_animation(recording_animation)
	if not animation:
		print("Animation not found: ", recording_animation)
		return
	
	# Get the relative path from AnimationPlayer to CollisionShape2D
	var rel_path = anim_player.get_node("..").get_path_to(collision_shape)
	print("Animation path to collision shape: ", rel_path)
	
	# Create or get tracks with correct node paths
	var tracks = {
		"disabled": _ensure_track(animation, str(rel_path) + ":disabled", Animation.TYPE_VALUE),
		"position": _ensure_track(animation, str(rel_path) + ":position", Animation.TYPE_VALUE),
		"scale": _ensure_track(animation, str(rel_path) + ":scale", Animation.TYPE_VALUE)
	}
	
	# Add shape-specific tracks
	if collision_shape.shape is RectangleShape2D:
		tracks["shape_size"] = _ensure_track(animation, str(rel_path) + ":shape:size", Animation.TYPE_VALUE)
	elif collision_shape.shape is CircleShape2D:
		tracks["radius"] = _ensure_track(animation, str(rel_path) + ":shape:radius", Animation.TYPE_VALUE)
	
	# Add keyframes
	for time in frame_data:
		var frame = frame_data[time]
		for property in frame:
			if tracks.has(property):
				var track_idx = tracks[property]
				animation.track_insert_key(track_idx, time, frame[property])
	
	print("Saved all recorded frames to animation!")

func _ensure_track(animation: Animation, path: String, type: int) -> int:
	var track_idx = animation.find_track(path, type)
	if track_idx == -1:
		track_idx = animation.add_track(type)
		animation.track_set_path(track_idx, path)
	return track_idx
