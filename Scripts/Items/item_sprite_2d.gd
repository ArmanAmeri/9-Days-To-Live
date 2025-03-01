extends Sprite2D

@export var outline_color: Color = Color(1, 1, 1, 1):
	set(value):
		outline_color = value
		if new_material:
			new_material.set_shader_parameter("outline_color", outline_color)

@onready var parent: CharacterBody2D = $".."

var new_material: ShaderMaterial

func _ready() -> void:
	new_material = ShaderMaterial.new()
	var shader = preload("res://Assets/Shaders/outline_shader.gdshader")
	if shader:
		new_material.shader = shader
		new_material.set_shader_parameter("outline_color", outline_color)
	else:
		print("Error: Shader not found at res://Assets/Shaders/outline_shader.gdshader")

func _process(_delta: float) -> void:
	if parent.show_outline:
		material = new_material
	else:
		material = null
