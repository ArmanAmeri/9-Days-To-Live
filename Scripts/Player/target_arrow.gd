extends CharacterBody2D

@onready var target: Marker2D = $Target
@onready var sprite: Sprite2D = $TargetArrowSprite
@onready var guiding_arrow: Node2D = $"../GuidingArrow"
@onready var coll: CollisionShape2D = $PhysicalBody
@onready var camera: Camera2D = $"../Camera2D"
@onready var player = get_tree().get_first_node_in_group("player")


var freeForm: bool = true
var touchingScreenEdge: bool = true
var targetPos: Vector2
var target_cursor_speed: float = 300.0  # Speed in pixels per second
var lastPos: Vector2

func _ready() -> void:
	coll.disabled = true

func _process(_delta: float) -> void:
	print(get_camera_boundaries())
	var direction: Vector2 = Vector2.ZERO
	if not freeForm:
		position = lastPos
		sprite.visible = false
		if Input.is_action_pressed("k"):
			position = Vector2.ZERO
			position.y = 25
			lastPos = position
		elif Input.is_action_pressed("i"):
			position = Vector2.ZERO
			position.y = -25
			lastPos = position
		elif Input.is_action_pressed("j"):
			position = Vector2.ZERO
			position.x = -25
			lastPos = position
		elif Input.is_action_pressed("l"):
			position = Vector2.ZERO
			position.x = 25
			lastPos = position
		
		if Input.is_action_pressed("k") and Input.is_action_pressed("l"):
			position = Vector2(25, 25)
		elif Input.is_action_pressed("k") and Input.is_action_pressed("j"):
			position = Vector2(-25, 25)
		elif Input.is_action_pressed("i") and Input.is_action_pressed("l"):
			position = Vector2(25, -25)
		elif Input.is_action_pressed("i") and Input.is_action_pressed("j"):
			position = Vector2(-25, -25)
		
	else: 
		if Input.is_action_pressed("i"):
			direction.y -= 1
		if Input.is_action_pressed("j"):
			direction.x -= 1
		if Input.is_action_pressed("k"):
			direction.y += 1
		if Input.is_action_pressed("l"):
			direction.x += 1
	
	print("target: ", targetPos)
	print("direction: ", direction)
	print("last positon: ", lastPos)
	print("positon: ", position)
	targetPos = target.global_position
	
	# Set the velocity based on direction and speed
	velocity = direction.normalized() * target_cursor_speed
	
	# Move the character
	move_and_slide()

func get_camera_boundaries():
	var viewport_rect = get_viewport_rect()
	var camera = get_viewport().get_camera_2d()
	var camera_position = camera.global_position
	# Calculate world boundaries
	var top_left = camera.get_screen_to_global(Vector2.ZERO)
	var bottom_right = camera.get_screen_to_global(viewport_rect.size)
	print("Camera boundaries: ", top_left, " to ", bottom_right)
	return {
		"top": top_left.y,
		"left": top_left.x,
		"bottom": bottom_right.y,
		"right": bottom_right.x
	}
