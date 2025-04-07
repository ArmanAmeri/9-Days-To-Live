extends Node

signal move_input(direction: Vector2)

@export var initial_state: State
@export var pathfindingcomp: PathfindingComponent
@export var los_component: LOSComponent

@onready var character_body = get_parent() as CharacterBody2D
@onready var state_label: Label = $"../StateLabel"

var current_state: State
var states: Dictionary = {}

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			print("Registered state: ", child.name.to_lower())
			child.transitioned.connect(on_child_transition)
		
		if initial_state:
			initial_state.enter()
			current_state = initial_state
			state_label.text = str(current_state.name)


func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		move_input.emit(current_state.move_direction)
		if current_state.has_method("physics_update"):
			current_state.physics_update(delta)

func on_child_transition(state, new_state_name):
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current_state:
		current_state.exit()
	
	new_state.enter()
	current_state = new_state
	state_label.text = str(current_state.name)
