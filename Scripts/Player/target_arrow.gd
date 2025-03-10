extends CharacterBody2D

@onready var target: Marker2D = $Target
@onready var sprite: Sprite2D = $TargetArrowSprite
@onready var guiding_arrow: Node2D = $"../GuidingArrow"
@onready var coll: CollisionShape2D = $PhysicalBody

var freeForm: bool = false
var targetPos: Vector2
var target_cursor_speed: float = 300.0  # Speed in pixels per second
var lastPos: Vector2

func _ready() -> void:
	coll.disabled = true

func _process(_delta: float) -> void:
	var direction: Vector2 = Vector2.ZERO
	
	if not freeForm:
		sprite.visible = false
		if Input.is_action_pressed("ø"):
			direction.y += 1
		if Input.is_action_pressed("p"):
			direction.y -= 1
		if Input.is_action_pressed("l"):
			direction.x -= 1
		if Input.is_action_pressed("æ"):
			direction.x += 1
		
		# Normalize the direction to ensure consistent speed in all directions
		if direction != Vector2.ZERO:
			direction = direction.normalized()
		
		# Update the position based on direction and speed
		position += direction * target_cursor_speed * _delta
		lastPos = position
	else: 
		if Input.is_action_pressed("p"):
			direction.y -= 1
		if Input.is_action_pressed("l"):
			direction.x -= 1
		if Input.is_action_pressed("ø"):
			direction.y += 1
		if Input.is_action_pressed("æ"):
			direction.x += 1
	
	print("target: ", targetPos)
	print("direction: ", direction)
	print("last position: ", lastPos)
	print("position: ", position)
	targetPos = target.global_position
	
	# Set the velocity based on direction and speed
	velocity = direction.normalized() * target_cursor_speed
	
	# Move the character
	move_and_slide()
