extends Node2D
class_name LOSComponent


@onready var ray1: RayCast2D = $Ray
@onready var ray2: RayCast2D = $Ray2
@onready var ray3: RayCast2D = $Ray3
@onready var ray4: RayCast2D = $Ray4
@onready var ray5: RayCast2D = $Ray5

@onready var ray_list: Array = [ray1, ray2, ray3, ray4, ray5]



func check_ray_collisions(rayarray: Array):
	var player_visible: bool
	for i in range(len(rayarray)):
		if rayarray[i].is_colliding():
			var collider = rayarray[i].get_collider()
			#shouldnt be HitboxComponent but temporarily is for testing
			if collider is Player or collider is HitboxComponent:
				player_visible = true
				break
			else: player_visible = false
	return player_visible
