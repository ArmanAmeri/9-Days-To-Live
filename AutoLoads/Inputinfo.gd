extends Node

var using_mouse: bool = false

func _process(_delta: float) -> void:
	
	#Interaction Keys
	if Input.is_action_just_pressed("interact"):
		Signalbus.key_interact.emit("f")
	
	#Movement Keys/Sigil Keys
	if Input.is_action_pressed("d"):
		Signalbus.key_d.emit()
	if Input.is_action_pressed("a"):
		Signalbus.key_a.emit()
	if Input.is_action_pressed("s"):
		Signalbus.key_s.emit()
	if Input.is_action_pressed("w"):
		Signalbus.key_w.emit()
	if Input.is_action_just_pressed("dash"):
		Signalbus.key_dash.emit()
	

	#Aim Keys
	if Input.is_action_pressed("p"):
		Signalbus.key_p.emit()
	if Input.is_action_pressed("l"):
		Signalbus.key_l.emit()
	if Input.is_action_pressed("ø"):
		Signalbus.key_ø.emit()
	if Input.is_action_pressed("æ"):
		Signalbus.key_æ.emit()
