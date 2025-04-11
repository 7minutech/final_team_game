extends Control

@onready var play_button = $UI/PlayButton
@onready var options_button = $UI/OptionsButton
@onready var volume_slider = $UI/VolumeSlider


func _ready():
	play_button.pressed.connect(on_play_pressed)
	options_button.pressed.connect(on_options_pressed)
	volume_slider.value_changed.connect(on_volume_changed)
	

func on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/test/TestEnemyMain2.tscn")

func on_options_pressed():
	print("Option Pressed")

func on_volume_changed(value):
	AudioServer.set_bus_volume_db(0, linear_to_db(value))
