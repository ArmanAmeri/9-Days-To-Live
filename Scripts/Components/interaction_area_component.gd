extends Area2D

class_name InteractionAreaComponent

@export var action_name: String = "interact"
@export var parent: CharacterBody2D


@onready var item_name : String = parent.item_name
@onready var description : String = itemLibrary.get_item_info(item_name, "description")
@onready var image_path : String = itemLibrary.get_item_info(item_name, "image_path")


var interact: Callable = func():
	pass


func _on_body_entered(_body: Node2D) -> void:
	InteractionManager.register_area(self)


func _on_body_exited(_body: Node2D) -> void:
	InteractionManager.unregister_area(self)
