extends Area2D

signal meele_range_entered()
signal meele_range_exited()


func _on_body_entered(body: Node2D) -> void:
	meele_range_entered.emit()

func _on_body_exited(body: Node2D) -> void:
	meele_range_exited.emit()
