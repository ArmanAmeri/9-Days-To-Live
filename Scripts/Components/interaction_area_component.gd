extends Area2D

class_name InteractionAreaComponent

@export var action_name: String = "interact"
@export var parent: Node2D
@export var item: bool
@export var chest: bool

var disabled_interaction: bool

@onready var item_name_id : String

@onready var item_name : String = "healing_potion"

func _ready() -> void:
	if item:
		item_name_id = itemLibrary.get_item_info(item_name, "name")


var interact: Callable = func():
	pass


func _on_body_entered(_body: Node2D) -> void:
	InteractionManager.register_area(self)


func _on_body_exited(_body: Node2D) -> void:
	InteractionManager.unregister_area(self)
