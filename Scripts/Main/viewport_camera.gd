extends Camera2D


func _process(delta: float) -> void:
	if is_instance_valid(Globals.camera):
		global_position = Globals.camera.global_position
		offset = Globals.camera.offset
		zoom = Globals.camera.zoom
		rotation_degrees = Globals.camera.rotation_degrees
