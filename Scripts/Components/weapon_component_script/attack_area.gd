@tool
extends Area2D
class_name AttackArea

# Array to store multiple collision shapes
var collision_shapes: Array[CollisionShape2D] = []
@export var anim_player: AnimationPlayer
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

# Dictionary to store frame data for all collision shapes
# Structure: {time: {shape_id: {shape_data}}}
var frame_data: Dictionary = {}

func _ready() -> void:
	# Find all collision shapes
	_find_collision_shapes()
			
	if collision_shapes.is_empty():
		print("WARNING: No CollisionShape2D found as children of AttackArea!")
	
	if not Engine.is_editor_hint():
		for shape in collision_shapes:
			shape.disabled = true
		# Change this line to connect to area_entered instead of body_entered
		area_entered.connect(_on_area_entered)
	else:
		if anim_player:
			anim_player.stop()

func _enter_tree() -> void:
	# Also try to find collision shapes when entering tree
	if collision_shapes.is_empty():
		_find_collision_shapes()

func _find_collision_shapes() -> void:
	collision_shapes.clear()
	for child in get_children():
		if child is CollisionShape2D:
			collision_shapes.append(child)
			print("Found collision shape: ", child.name)
	
	print("Total collision shapes found: ", collision_shapes.size())

# Replace _on_body_entered with _on_area_entered
func _on_area_entered(area: Area2D) -> void:
	print("Area entered attack area: ", area.name)
	print("Is HitboxComponent: ", area is HitboxComponent)
	print("Is in damageable group: ", area.is_in_group("damageable"))
	print("Is not owner: ", area != owner)
	
	# Check if it's a HitboxComponent and in the damageable group
	if area is HitboxComponent and area.is_in_group("damageable") and area != owner:
		print("Valid hitbox detected! Applying damage...")
		if attack_data:
			attack_data.apply_to_target(area, global_position)
		else:
			print("ERROR: No attack_data available!")
		hit_confirmed.emit(area)

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
	
	# Try to find collision shapes again if we don't have any
	if collision_shapes.is_empty():
		_find_collision_shapes()
	
	if collision_shapes.is_empty():
		print("No collision shapes found!")
		return
		
	if recording_animation.is_empty():
		print("No animation selected!")
		return
		
	# Create a frame entry for this timestamp if it doesn't exist
	if not frame_data.has(current_time):
		frame_data[current_time] = {}
	
	# Record data for each collision shape
	for i in range(collision_shapes.size()):
		var shape = collision_shapes[i]
		var shape_id = str(i) + "_" + shape.name
		
		var frame_info = {
			"disabled": shape.disabled,
			"position": shape.position,
			"scale": shape.scale
		}
		
		# Record shape-specific data
		if shape.shape is RectangleShape2D:
			frame_info["shape_size"] = shape.shape.size
		elif shape.shape is CircleShape2D:
			frame_info["radius"] = shape.shape.radius
		
		frame_data[current_time][shape_id] = frame_info
	
	print("Recorded frame at time: ", current_time, " seconds with ", collision_shapes.size(), " shapes")
	
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
	
	# Dictionary to store track indices for each shape and property
	var all_tracks = {}
	
	# First, ensure all tracks exist
	for shape_idx in range(collision_shapes.size()):
		var shape = collision_shapes[shape_idx]
		var shape_id = str(shape_idx) + "_" + shape.name
		all_tracks[shape_id] = {}
		
		# Get the relative path from AnimationPlayer to CollisionShape2D
		var rel_path = anim_player.get_node("..").get_path_to(shape)
		print("Animation path to collision shape ", shape.name, ": ", rel_path)
		
		# Create or get tracks with correct node paths
		all_tracks[shape_id]["disabled"] = _ensure_track(animation, str(rel_path) + ":disabled", Animation.TYPE_VALUE)
		all_tracks[shape_id]["position"] = _ensure_track(animation, str(rel_path) + ":position", Animation.TYPE_VALUE)
		all_tracks[shape_id]["scale"] = _ensure_track(animation, str(rel_path) + ":scale", Animation.TYPE_VALUE)
		
		# Add shape-specific tracks
		if shape.shape is RectangleShape2D:
			all_tracks[shape_id]["shape_size"] = _ensure_track(animation, str(rel_path) + ":shape:size", Animation.TYPE_VALUE)
		elif shape.shape is CircleShape2D:
			all_tracks[shape_id]["radius"] = _ensure_track(animation, str(rel_path) + ":shape:radius", Animation.TYPE_VALUE)
	
	# Add keyframes for all shapes
	for time in frame_data:
		for shape_id in frame_data[time]:
			var frame = frame_data[time][shape_id]
			
			# Only add keyframes if we have tracks for this shape
			if all_tracks.has(shape_id):
				for property in frame:
					if all_tracks[shape_id].has(property):
						var track_idx = all_tracks[shape_id][property]
						animation.track_insert_key(track_idx, time, frame[property])
	
	print("Saved all recorded frames to animation for ", collision_shapes.size(), " shapes!")

func _ensure_track(animation: Animation, path: String, type: int) -> int:
	var track_idx = animation.find_track(path, type)
	if track_idx == -1:
		track_idx = animation.add_track(type)
		animation.track_set_path(track_idx, path)
	return track_idx
