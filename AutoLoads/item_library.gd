extends Node2D

class_name ItemLibrary

const Library:  Dictionary = {
	#Consumables
	"healing_potion": {
		"ID": "healing_potion",
		"name": "Healing Potion",
		"stackable": true, 
		"amount": 1,
		"monetary_value": 10,
		"rarity": "common",
		"description": "A Potion To Restore Health",
		"image_path": "res://Assets/Sprites/Items/PotionItemPlaceholder.png",
		"scene_path": "res://Scenes/Items/healing_potion.tscn",
		"item_type": "consumable"
	}
	#Valuables
	#Weapons
	#Armor
} 


func get_item_info(item_name: String, info: String):
	print(info)
	for item in Library:
		if item == item_name:
			if info in Library[item]:
				print(Library[item][info])
				return Library[item][info]
			else:
				return Library[item]
		else:
			print("Item Not Found")
