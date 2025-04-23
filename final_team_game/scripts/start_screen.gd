extends Control

@onready var play_button = $UI/PlayButton
@onready var options_button = $UI/OptionsButton
@onready var volume_slider = $UI/VolumeSlider
@onready var hover_sound = $Hover
@onready var click_sound = $ClickSound
@onready var shop_button = $UI/ShopButton
 
var options_open = false

func _ready():
	play_button.pressed.connect(on_play_pressed)
	play_button.mouse_entered.connect(on_hover)
	options_button.pressed.connect(on_options_pressed)
	options_button.mouse_entered.connect(on_hover)
	volume_slider.value_changed.connect(on_volume_changed)
	volume_slider.visible = false
	shop_button.pressed.connect(on_shop_pressed)
	shop_button.mouse_entered.connect(on_hover)
	

func on_play_pressed():
	$MenuMusic.stop()
	click_sound.play()
	await click_sound.finished
	get_tree().change_scene_to_file("res://scenes/test/TestEnemyMain2.tscn")
	

func on_options_pressed():
	click_sound.play()
	options_open = !options_open
	volume_slider.visible = options_open

func on_volume_changed(value):
	AudioServer.set_bus_volume_db(0, linear_to_db(value))

## HoverSound func
func on_hover():
	hover_sound.play()

func on_shop_pressed():
	click_sound.play()
	await click_sound.finished
	get_tree().change_scene_to_file("res://scenes/shop.tscn")
