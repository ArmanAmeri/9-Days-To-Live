extends Node2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var label = $Label
@onready var text_area: ColorRect = $TextArea
@onready var item_name: Label = $TextArea/ItemName

const base_text = "[F] to "

var active_areas = []
var can_interact = true
var currently_highlighted: InteractionAreaComponent = null  # Track the currently highlighted item

func register_area(area: InteractionAreaComponent):
	if not area.disabled_interaction:
		active_areas.push_back(area)
	
func unregister_area(area: InteractionAreaComponent):
	var index = active_areas.find(area)
	if index != -1:
		if active_areas[index].item:
			active_areas[index].parent.show_outline = false
		active_areas.remove_at(index)
		
	if area == currently_highlighted:
		currently_highlighted = null

func _process(_delta: float) -> void:
	if active_areas.size() > 0 && can_interact:
		active_areas.sort_custom(_sort_by_distance_to_player)
		
		# Highlight the closest item
		var closest_area = active_areas[0]
		if closest_area != currently_highlighted:
			if currently_highlighted != null && currently_highlighted.item:
				currently_highlighted.parent.show_outline = false  # Hide the outline of the previously highlighted item
			if closest_area.item:
				closest_area.parent.show_outline = true  # Show the outline of the new closest item
			currently_highlighted = closest_area
		
		if not active_areas[0].disabled_interaction:
			label.text = base_text + closest_area.action_name
			label.global_position = closest_area.global_position
			if closest_area.item:
				label.global_position.y -= 66
				text_area.global_position = closest_area.global_position
				text_area.global_position.y -= 45
				text_area.size.x = item_name.size.x + 5
				text_area.size.y = item_name.size.y + 5
				text_area.global_position.x -= text_area.size.x / 2
				text_area.show()
			else: 
				label.global_position.y -= 40
				text_area.hide()
			label.global_position.x -= label.size.x / 2
			label.show()

			item_name.text = closest_area.item_name_id
			item_name.global_position = closest_area.global_position
			item_name.global_position.y -= 45
			item_name.global_position.x -= item_name.size.x / 2
			item_name.show()
			
			
		else:
			label.hide()
			item_name.hide()
			text_area.hide()
			
	else:
		label.hide()
		item_name.hide()
		text_area.hide()
		
		if currently_highlighted != null && currently_highlighted.item:
			currently_highlighted.parent.show_outline = false  # Hide the outline when no areas are active
			currently_highlighted = null

func _sort_by_distance_to_player(area1, area2):
	var area1_to_player = player.global_position.distance_to(area1.global_position)
	var area2_to_player = player.global_position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") && can_interact:
		if active_areas.size() > 0: 
			can_interact = false
			label.hide()
			
			if active_areas[0].chest:
				if not active_areas[0].disabled_interaction:
					await active_areas[0].interact.call()
					active_areas[0].disabled_interaction = true
			else:
				await active_areas[0].interact.call()
			
			can_interact = true
