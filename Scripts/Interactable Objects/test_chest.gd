extends Node2D

@onready var interaction_area: InteractionAreaComponent = $InteractionAreaComponent
@onready var player = get_tree().get_first_node_in_group("player")
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var item_dropper_component: Node2D = $ItemDropperComponent

@onready var kills: int = 0

@export var drops : Array[DropData]

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	animation.connect("animation_finished", _on_animation_finished)
	
func _on_interact():
	animation.play("open")

func _on_animation_finished(_anim_name: String):
	item_dropper_component.drop_items()
	kills = kills + 1
	print("kill count: ", kills)
