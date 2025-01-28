extends Area2D

class_name InteractionAreaComponent

@export var action_name: String = "interact"
@export var parent: Node2D
@export var item: bool

@onready var description : String
@onready var image_path : String

@onready var item_name : String = "healing_potion"

func _ready() -> void:
	if item:
		description = itemLibrary.get_item_info(item_name, "description")
		image_path = itemLibrary.get_item_info(item_name, "image_path")


var interact: Callable = func():
	pass


func _on_body_entered(_body: Node2D) -> void:
	InteractionManager.register_area(self)


func _on_body_exited(_body: Node2D) -> void:
	InteractionManager.unregister_area(self)
