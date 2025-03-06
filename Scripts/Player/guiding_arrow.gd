extends Node2D

var lookPos: Vector2
@onready var aim: Marker2D = $Aim

var using_mouse: bool = true

func _process(_delta: float) -> void:
	
	if using_mouse:
		lookPos = get_global_mouse_position()
	else:
		#lookPos = Inputinfo.lookDir
		pass
	
	look_at(lookPos)
	queue_redraw()

func _draw():
	draw_rect(Rect2(aim.position - Vector2(1.5, 1.5), Vector2(3.0, 3.0)), Color.GREEN, false, 2.0)
