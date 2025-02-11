@tool
class_name AttackArea
extends Area2D

enum AttackShape {
	CIRCLE,      # For AoE attacks
	RECTANGLE,   # For straight thrusts
	ARC,        # For sweep attacks
}

@export var shape_type: AttackShape = AttackShape.RECTANGLE:
	set(value):
		shape_type = value
		_update_shape()

@export var range: float = 50.0:
	set(value):
		range = value
		_update_shape()

@export var width: float = 20.0:
	set(value):
		width = value
		_update_shape()

@export var arc_degrees: float = 90.0:
	set(value):
		arc_degrees = value
		_update_shape()

var current_shape: CollisionShape2D
var current_polygon: CollisionPolygon2D

func _ready() -> void:
	_update_shape()

func _update_shape() -> void:
	# Don't update if we're not in the editor and the game isn't running
	if not Engine.is_editor_hint() and not is_inside_tree():
		return
		
	# Clear existing shapes
	if current_shape:
		remove_child(current_shape)
		current_shape.queue_free()
	if current_polygon:
		remove_child(current_polygon)
		current_polygon.queue_free()
	
	match shape_type:
		AttackShape.CIRCLE:
			_create_circle()
		AttackShape.RECTANGLE:
			_create_rectangle()
		AttackShape.ARC:
			_create_arc()

func _create_circle() -> void:
	current_shape = CollisionShape2D.new()
	var circle = CircleShape2D.new()
	circle.radius = range
	current_shape.shape = circle
	add_child(current_shape)
	if Engine.is_editor_hint():
		current_shape.owner = get_tree().edited_scene_root

func _create_rectangle() -> void:
	current_shape = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.size = Vector2(range, width)
	current_shape.shape = rect
	current_shape.position = Vector2(range/2, 0)  # Center the rectangle in front
	add_child(current_shape)
	if Engine.is_editor_hint():
		current_shape.owner = get_tree().edited_scene_root

func _create_arc() -> void:
	current_polygon = CollisionPolygon2D.new()
	var points = PackedVector2Array()
	points.append(Vector2.ZERO)  # Center point
	
	# Create arc points
	var num_points = 8  # More points = smoother arc
	var half_angle = deg_to_rad(arc_degrees / 2)
	var start_angle = -half_angle
	var angle_step = deg_to_rad(arc_degrees) / (num_points - 1)
	
	for i in range(num_points):
		var angle = start_angle + (i * angle_step)
		var point = Vector2(
			cos(angle) * range,
			sin(angle) * range
		)
		points.append(point)
	
	current_polygon.polygon = points
	add_child(current_polygon)
	if Engine.is_editor_hint():
		current_polygon.owner = get_tree().edited_scene_root

# Helper functions to quickly change attack shapes
func make_circle(new_range: float) -> void:
	range = new_range
	shape_type = AttackShape.CIRCLE

func make_thrust(new_range: float, new_width: float) -> void:
	range = new_range
	width = new_width
	shape_type = AttackShape.RECTANGLE

func make_sweep(new_range: float, new_arc_degrees: float) -> void:
	range = new_range
	arc_degrees = new_arc_degrees
	shape_type = AttackShape.ARC
