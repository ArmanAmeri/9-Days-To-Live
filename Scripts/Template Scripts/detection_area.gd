extends Area2D

signal item_area_entered()

@onready var pick_up_label: Label = $"../PickUpItemLabel"

func _ready():
	pick_up_label.visible = false

func _on_body_entered(_body: Node2D) -> void:
	pick_up_label.visible = true
	item_area_entered.emit()

func _on_body_exited(_body: Node2D) -> void:
	pick_up_label.visible = false
	
