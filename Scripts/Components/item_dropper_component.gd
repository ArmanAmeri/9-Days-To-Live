extends Node2D

@export_category("Item Drops")
@export var drops : Array[DropData]


func drop_items() -> void:
	if drops.size() == 0:
		return
	
	
	for i in drops.size():
		if drops[i] == null or drops[i].item_ID == null:
			continue
		var drop_count : int = drops[i].get_drop_count()
		for j in drop_count:
			var drop_name : String = drops[i].item_ID
			var drop_item_path = load(itemLibrary.get_item_info(drop_name, "scene_path"))
			var drop = drop_item_path.instantiate()
			get_node("/root/SceneManager/ItemsOnGround").add_child(drop)
			drop.global_position = get_parent().global_position + Vector2(randf() * 16, randf() * 16)
			
	pass
