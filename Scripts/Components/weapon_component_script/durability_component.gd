class_name DurabilityComponent
extends Node2D

signal durability_changed(new_value: float)
signal durability_depleted


@onready var id_name: String = get_parent().id_name if get_parent() is Weapon else null
@onready var max_durability: float = itemLibrary.get_item_info(id_name, "max_durability")
@export var indestructable: bool = true
var current_durability: float = 100.0

func _ready() -> void:
	current_durability = max_durability

func reduce_durability(amount: float) -> void:
	if not indestructable:
		current_durability = maxf(0.0, current_durability - amount)
		durability_changed.emit(current_durability)
		
		if current_durability <= 0:
			durability_depleted.emit()
	else:
		return

func repair() -> void:
	if not indestructable:
		current_durability = max_durability
		durability_changed.emit(current_durability)
	else:
		return


func has_durability() -> bool:
	return current_durability > 0
