extends Area2D

@export var attack: CollisionShape2D


func _process(_delta: float) -> void:
	if Input.is_action_pressed("e"):
		attack.disabled = false
	else:
		attack.disabled = true


func _on_body_entered(body: Node2D) -> void:
	body.damage()
