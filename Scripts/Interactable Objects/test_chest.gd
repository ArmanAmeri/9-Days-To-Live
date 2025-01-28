extends Node2D

@export var item_name: String = "healing_potion"

@onready var interaction_area: InteractionAreaComponent = $InteractionAreaComponent
@onready var player = get_tree().get_first_node_in_group("player")
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var item_dropper_component: Node2D = $ItemDropperComponent


func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	
func _on_interact():
	animation.play("open")
	item_dropper_component.drop_items()
