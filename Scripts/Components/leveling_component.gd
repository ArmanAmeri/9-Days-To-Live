extends Area2D

# Player stats
var level: int = 1  # Start at level 1
var xp: int = 0
var xp_to_next_level: int = 0  # Will be calculated in _ready()

# XP formula parameters
@export var base_xp: int = 10          # Base XP required at level 1
@export var growth_factor_below_50: float = 1.125  # Steeper growth factor before level 50
@export var growth_factor_above_50: float = 1.05  # Slower growth factor after level 50
@export var smoothing_factor: int = 50    # Smoothing factor (soft cap around this level)
@export var max_xp_cap: int = 999999      # XP cap at level 100

# Reference to the Label node
@onready var xp_label: Label = $"../Label"


func _ready():
	update_xp_to_next_level()  # Initialize XP to next level
	update_label()

# Add XP and check for level-up
func add_xp(amount: int):
	xp += amount
	print("Gained ", amount, " XP!")
	check_level_up()

# Check if the player has enough XP to level up
func check_level_up():
	while xp >= xp_to_next_level and level < 100:
		xp -= xp_to_next_level
		level_up()

# Level up the player
func level_up():
	level += 1
	level = clamp(level, 1, 100)  # Ensure level doesn't exceed 100
	update_xp_to_next_level()
	print("Level Up! You are now level ", level)
	print("To Next Level ", xp_to_next_level)

# Update the XP required for the next level
func update_xp_to_next_level():
	if level < smoothing_factor:
		# Use a steeper growth factor before level 50
		xp_to_next_level = int(base_xp * pow(growth_factor_below_50, level - 1))
	else:
		# Calculate XP required at level 50
		var xp_at_50 = int(base_xp * pow(growth_factor_below_50, smoothing_factor - 1))
		# Use a slower growth factor after level 50
		xp_to_next_level = int(xp_at_50 * pow(growth_factor_above_50, level - smoothing_factor))
	
	# Cap the XP at level 100
	if level >= 100:
		xp_to_next_level = max_xp_cap

# Update the Label text
func update_label():
	if xp_label:
		xp_label.text = "LEVEL " + str(level) + " XP: " + str(xp) + ", Next: " + str(xp_to_next_level)

# Handle XP orbs entering the area
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("xp") and body.has_method("xp_gained"):
		add_xp(body.amount)
		update_label()
		body.xp_gained()
