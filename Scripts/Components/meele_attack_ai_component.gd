extends Area2D

signal meele_range_entered()
signal meele_range_exited()

func _ready() -> void:
	self.connect("body_entered", _on_body_entered)
	self.connect("body_exited", _on_body_exited)

#I dont know why this doesnt work rn
func _on_body_entered(_body: Node2D) -> void:
	print("Body entered")
	meele_range_entered.emit()

func _on_body_exited(_body: Node2D) -> void:
	print("Body exited")
	meele_range_exited.emit()
