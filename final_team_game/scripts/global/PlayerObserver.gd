extends Node

### Constants ###
const CHEST_COIN_AMOUNT: int = 30
const SAVE_FILE_PATH = "user://savegame.json"

enum upgrade_type {AVAILABLE, ON, OFF}

### Variables ###
var player: Player
var player_camera: Camera2D

# Stats variables
var max_xp: int 
var current_xp: int
var current_level: int
var max_hp: int
var current_hp: int
var coins: int = 0
var movement_speed: float 
var health_regen: float = 0.0

var upgrade
var permanent_upgrade: Dictionary = {
	"xp": upgrade_type.AVAILABLE,
	"pizza": upgrade_type.AVAILABLE,
	"music": upgrade_type.AVAILABLE,
	"twice": upgrade_type.AVAILABLE
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug"):
		for key in permanent_upgrade.keys():
			print(key + ": " + str(permanent_upgrade[key]))
	pass

# Function to return all available info as a string
func toString() -> String:
	var text: String = "Max Health: " + str(max_hp)
	text += "\nCurrent Health: " + str(current_hp)
	text += "\nPlayer Level: " + str(current_level)
	text += "\nMax XP: " + str(max_xp)
	text += "\nCurrent XP: " + str(current_xp)
	text += "\nCurrent coins: " + str(coins)
	return text

func add_coins(extra_coins: int) -> void:
	coins += extra_coins 
	update_coins(coins, SAVE_FILE_PATH)

func update_coins(new_val: int, save_path):
	print("updating...")

	if not FileAccess.file_exists(save_path):
		push_error("Save file not found!")
		return

	var file = FileAccess.open(save_path, FileAccess.READ)
	var content = file.get_as_text()
	file.close()

	var data = JSON.parse_string(content)
	if typeof(data) != TYPE_DICTIONARY:
		push_error("Invalid JSON format!")
		return

	data["coins"] = new_val

	file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(data, "\t"))  # "\t" adds indentation
	file.close()

	print("Coins updated to:", new_val)
