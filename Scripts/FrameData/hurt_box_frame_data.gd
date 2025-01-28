extends Area2D

class_name HurtBoxFrameData

@export var animation_frames: Array[FrameData] = []  # Array to hold FrameData resources

func _ready() -> void:
	# Call your setup function
	update_collision_shapes()

func update_collision_shapes():
	# Implement your function to update collision shapes based on the current frame
	var current_frame = get_current_animation_frame()  # Implement this function as necessary
	if current_frame >= 0 and current_frame < animation_frames.size():
		var frame_data = animation_frames[current_frame]
		# Call a method to set up collision shapes based on frame_data
		setup_collision_shapes(frame_data.collision_shapes)

func get_current_animation_frame() -> int:
	# Implement your method for determining the current animation frame index
	return 0  # Placeholder implementation

func setup_collision_shapes(shapes: Array):
	# Implement the logic to setup collision shapes based on the provided shapes
	pass  # Placeholder implementation
