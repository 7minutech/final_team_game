extends Control

@onready var play_button = $UI/PlayButton
@onready var options_button = $UI/OptionsButton
@onready var volume_slider = $UI/VolumeSlider
@onready var hover_sound = $HoverSound
@onready var click_sound = $ClickSound
@onready var shop_button = $UI/ShopButton
@onready var controls_button = $UI/ControlsButton
 
var options_open = false

func _ready():
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
