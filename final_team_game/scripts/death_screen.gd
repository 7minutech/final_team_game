extends Control

@onready var restart_button = $VBoxContainer/RestartButton
@onready var quit_button = $VBoxContainer/QuitButton
@onready var death_sound = $DeathSound
@onready var hover_sound = $Hover
@onready var click_sound = $ClickSound



func _ready():
	if restart_button:
		restart_button.pressed.connect(on_restart_pressed)
		restart_button.mouse_entered.connect(on_hover)

	if quit_button:
		quit_button.pressed.connect(on_quit_pressed)
		quit_button.mouse_entered.connect(on_hover)

	if death_sound:
		death_sound.play()

func on_hover():
	hover_sound.play()

func on_restart_pressed():
	click_sound.play()
	await click_sound.finished
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")

func on_quit_pressed():
	click_sound.play()
	await click_sound.finished
	get_tree().change_scene_to_file("res://scenes/start_screen.tscn")
