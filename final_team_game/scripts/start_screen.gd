extends Control

@onready var play_button = $UI/PlayButton
@onready var options_button = $UI/OptionsButton
@onready var hover_sound = $HoverSound
@onready var click_sound = $ClickSound
@onready var shop_button = $UI/ShopButton
@onready var controls_button = $UI/ControlsButton
 
var options_open = false

func _ready():
	create_save_file(PlayerObserver.SAVE_FILE_PATH	)
	PlayerObserver.coins = load_coins(PlayerObserver.SAVE_FILE_PATH)
	PlayerObserver.permanent_upgrade = load_upgrades(PlayerObserver.SAVE_FILE_PATH)
	play_button.pressed.connect(on_play_pressed)
	play_button.mouse_entered.connect(on_hover)
	#options_button.pressed.connect(on_options_pressed)
	options_button.mouse_entered.connect(on_hover)
	shop_button.pressed.connect(on_shop_pressed)
	shop_button.mouse_entered.connect(on_hover)
	controls_button.pressed.connect(on_controls_pressed)
	controls_button.mouse_entered.connect(on_hover)
	
	

func on_play_pressed():
	StartScreenMusic.stop()
	click_sound.play()
	await click_sound.finished
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")
	

func on_volume_changed(value):
	AudioServer.set_bus_volume_db(0, linear_to_db(value))

## HoverSound func
func on_hover():
	hover_sound.play()

func on_shop_pressed():
	click_sound.play()
	await click_sound.finished
	get_tree().change_scene_to_file("res://scenes/shop.tscn")

func on_controls_pressed():
	click_sound.play()
	await click_sound.finished
	get_tree().change_scene_to_file("res://scenes/controls_menu.tscn")


func _on_options_button_pressed() -> void:
	click_sound.play()
	await click_sound.finished
	get_tree().change_scene_to_file("res://scenes/options_menu.tscn")
	pass # Replace with function body.
	
func create_save_file(save_path: String):
	if not FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.WRITE)
		file.store_string(PlayerObserver.DEFAULT_SAVE_VALUES)
		file.close()
		print("Save file created at:", save_path)
	else:
		print("Save file already exists at:", save_path)
	print("Resolved user:// path:", ProjectSettings.globalize_path(save_path))

func load_coins(save_path: String) -> int:	
	print("Loading coins from:", save_path)

	if not FileAccess.file_exists(save_path):
		print("Save file not found. Returning 0.")
		return 0

	var file = FileAccess.open(save_path, FileAccess.READ)
	if file == null:
		print("Failed to open save file. Returning 0.")
		return 0

	var content = file.get_as_text()
	file.close()
	print("File content:", content)

	var parse_result = JSON.parse_string(content)
	if typeof(parse_result) != TYPE_DICTIONARY:
		print("JSON parse failed or content is not a dictionary. Returning 0.")
		return 0

	var data: Dictionary = parse_result

	if not data.has("coins"):
		print("'coins' key missing in JSON. Returning 0.")
		return 0

	var saved_coins: int = data["coins"]
	print("Loaded coins:", saved_coins)
	return saved_coins

func load_upgrades(save_path: String) -> Dictionary:
	print("Loading upgrades from:", save_path)

	if not FileAccess.file_exists(save_path):
		print("Save file not found. Returning 0.")
		PlayerObserver.permanent_upgrade

	var file = FileAccess.open(save_path, FileAccess.READ)
	if file == null:
		print("Failed to open save file. Returning 0.")
		PlayerObserver.permanent_upgrade

	var content = file.get_as_text()
	file.close()
	print("File content:", content)

	var parse_result = JSON.parse_string(content)
	if typeof(parse_result) != TYPE_DICTIONARY:
		print("JSON parse failed or content is not a dictionary. Returning 0.")
		return PlayerObserver.permanent_upgrade

	var data: Dictionary = parse_result

	if not data.has_all(["xp", "music", "pizza", "twice" ]):
		print("upgrade keys missing in JSON. Returning default permanent upgrades.")
		return PlayerObserver.permanent_upgrade

	var saved_upgrades: Dictionary = {
		"xp": data.xp,
		"music": data.music,
		"pizza": data.pizza,
		"twice": data.twice
		}
	print("Loaded upgrades:", saved_upgrades)
	return saved_upgrades
