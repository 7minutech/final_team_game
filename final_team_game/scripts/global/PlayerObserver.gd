extends Node


### Variables ###
var player: Player
var player_camera: Camera2D

# Stats variables
var max_xp: int 
var current_xp: int
var current_level: int
var max_hp: int
var current_hp: int
var coins: int = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


# Function to return all available info as a string
func toString() -> String:
	var text: String = "Max Health: " + str(max_hp)
	text += "\nCurrent Health: " + str(current_hp)
	text += "\nPlayer Level: " + str(current_level)
	text += "\nMax XP: " + str(max_xp)
	text += "\nCurrent XP: " + str(current_xp)
	return text
