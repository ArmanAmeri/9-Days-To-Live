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
	position = lastPos
	
	if not freeForm:
		sprite.visible = true
		if Input.is_action_pressed("ø"):
			position = Vector2.ZERO
			position.y = 25
			lastPos = position
		if Input.is_action_pressed("p"):
			position = Vector2.ZERO
			position.y = -25
			lastPos = position
		if Input.is_action_pressed("l"):
			position = Vector2.ZERO
			position.x = -25
			lastPos = position
		if Input.is_action_pressed("æ"):
			position = Vector2.ZERO
			position.x = 25
			lastPos = position
		
		if Input.is_action_pressed("ø") and Input.is_action_pressed("æ"):
			position = Vector2(25, 25)
		if Input.is_action_pressed("ø") and Input.is_action_pressed("l"):
			position = Vector2(-25, 25)
		if Input.is_action_pressed("p") and Input.is_action_pressed("æ"):
			position = Vector2(25, -25)
		if Input.is_action_pressed("p") and Input.is_action_pressed("l"):
			position = Vector2(-25, -25)
		
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
	print("last positon: ", lastPos)
	print("positon: ", position)
	targetPos = target.global_position
	
	# Set the velocity based on direction and speed
	velocity = direction.normalized() * target_cursor_speed
	
	# Move the character
	move_and_slide()
