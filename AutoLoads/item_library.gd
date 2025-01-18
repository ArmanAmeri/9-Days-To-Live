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
		"item_type": "consumable"
	}
	#Valuables
	#Weapons
	#Armor
} 


func get_item_info(item_name: String):
	for item in Library:
		if item == item_name:
			print(item)
			print(item_name)
			return Library[item]
		else:
			print("Item Not Found")
