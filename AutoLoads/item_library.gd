extends Node2D

class_name ItemLibrary

const Library:  Dictionary = {
	#XP
	"extreme_xp": {
		"ID": "extreme_xp",
		"name": "Extreme Expirience",
		"amount": 10000,
		"image_path": "res://Assets/Sprites/Items/extreme_xp.png",
		"scene_path": "res://Scenes/Items/extreme_xp.tscn",
	},
	
	"high_xp": {
		"ID": "high_xp",
		"name": "High Expirience",
		"amount": 1000,
		"image_path": "res://Assets/Sprites/Items/high_xp.png",
		"scene_path": "res://Scenes/Items/high_xp.tscn",
	},
	
	"mid_xp": {
		"ID": "mid_xp",
		"name": "Medium Expirience",
		"amount": 100,
		"image_path": "res://Assets/Sprites/Items/mid_xp.png",
		"scene_path": "res://Scenes/Items/mid_xp.tscn",
	},
	
	"low_xp": {
		"ID": "low_xp",
		"name": "Low Expirience",
		"amount": 25,
		"image_path": "res://Assets/Sprites/Items/low_xp.png",
		"scene_path": "res://Scenes/Items/low_xp.tscn",
	},
	
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
	},
	#Valuables
	
	#Weapons
	"iron_sword": {
		"ID": "iron_sword",
		"name": "Iron Sword",
		"stackable": false, 
		"amount": 1,
		"monetary_value": 5,
		"rarity": "common",
		"description": "A Simple Sword Made By A Common Blacksmith",
		"image_path": "none",
		"scene_path": "none",
		"item_type": "weapon",
		"weapon_type": "sword",
		"damage": 10,
		"attack_speed": 2.5,
		"range": "Medium",
		"weight": 10,
		"damage_type": "slashing",
		"inflicted_effect": "bleed"
	},
	
	#Armor
} 


func get_item_info(item_name: String, info: String):
	print("Item Name: ", item_name, "| Requested Item Info: ", info)
	for item in Library:
		if item == item_name:
			if info in Library[item]:
				print("Retrieved Info: ", Library[item][info])
				return Library[item][info]
			else:
				return Library[item]
	
	print("Item Not Found: ", item_name, "| Item Info: ", info)
	return null



var damage_types_info: String = '
"slashing" = bleed = ?cant heal?
"Bludgeoning" = stun = vurneable
"Piercing" = slowed / pierce trough armor points

Physical damage (bludgeoning, piercing, slashing)
Elemental damage (acid, cold, lightning, poison, thunder)
Magical damage (force, necrotic, psychic, radiant)

StatusEffect {
	# Damage Over Time
	POISON,        # Deals damage each tick
	BLEED,         # Physical damage over time
	BURN,          # Fire damage over time
	DECAY,         # Percentage-based health loss
	
	# Movement Effects
	SLOW,          # Reduced movement speed
	STUN,          # Cannot move or act
	FREEZE,        # Immobilized and take increased damage
	KNOCKBACK,     # Forced movement in direction
	ROOT,          # Cannot move but can still act
	
	# Debuffs
	BLIND,         # Reduced accuracy/miss chance
	WEAKNESS,      # Reduced damage output
	SILENCE,       # Cannot use abilities/spells
	VULNERABLE,    # Take increased damage
	DISARM,        # Cannot use weapons
	CONFUSED,      # Random movement/targeting
	
	# Positive Status
	REGENERATION,  # Health recovery over time
	HASTE,         # Increased movement speed
	SHIELD,        # Temporary health/damage absorption
	INVISIBLE,     # Cannot be seen by enemies
	STRENGTH,      # Increased damage
	
	# Mental Effects
	FEAR,          # Forces target to flee
	CHARM,         # Temporarily switches allegiance
	SLEEP,         # Incapacitated until damaged
	TAUNT,         # Forced to attack source
	
	# Special
	CURSE,         # Custom negative effect
	MARKED,        # Takes bonus damage from certain attacks
	SHOCK,         # Chance to spread damage to nearby targets
	PETRIFY       # Turned to stone, invulnerable but cannot act
}


DamageType {
	# Physical Damage
	SLASHING,    # Swords, axes, claws
	PIERCING,    # Spears, arrows, daggers
	CRUSHING,    # Hammers, maces, fists
	RENDING,     # Tearing/shredding damage
	
	# Elemental Damage
	FIRE,        # Burns, flame weapons
	ICE,         # Frost, freezing
	LIGHTNING,   # Electric, thunder
	EARTH,       # Stone, crystal
	WIND,        # Air, pressure
	WATER,       # Liquid, drowning
	
	# Magical Damage
	ARCANE,      # Pure magical energy
	HOLY,        # Divine, sacred
	DARK,        # Shadow, unholy
	CHAOS,       # Random, unstable
	VOID,        # Space, gravity
	
	# Special Types
	POISON,      # Toxins, venom
	PSYCHIC,     # Mental damage
	SONIC,       # Sound-based
	COSMIC,      # Star, space
	TRUE,        # Ignores resistances
	
	# Composite Types
	FROSTFIRE,   # Combined ice and fire
	PLASMA,      # Heat and lightning
	NECROTIC     # Death and decay
}

' 

var defualt_item_info: String = '    
"none": {
		"ID": "none",
		"name": "none",
		"stackable": none, 
		"amount": none,
		"monetary_value": none,
		"rarity": "none",
		"description": "none",
		"image_path": "none",
		"scene_path": "none",
		"item_type": "none"
	},
								   '

var defualt_weapon_info: String = '    
"none": {
		"ID": "none",
		"name": "none",
		"stackable": none, 
		"amount": none,
		"monetary_value": none,
		"rarity": "none",
		"description": "none",
		"image_path": "none",
		"scene_path": "none",
		"item_type": "none",
		"weapon_type": "none",
		"damage": none,
		"attack_speed": none,
		"range": none,
		"weight": none,
		"damage_type": "none",
		"inflicted_effect": "none"
	},                                 '

#Enemy stuff (not done)
var default_enemy_info: String = '
	"none": {
		"ID": "none"
		"name": "none"
		"enemy_type": "melee"
		"damage": none
		"speed": none
	}
'
