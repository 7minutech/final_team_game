extends Control


@onready var hover_sound = $HoverSound
@onready var click_sound = $ClickSound
@onready var back_button = $BackButton

func _ready():
	back_button.pressed.connect(on_back_pressed)
	back_button.mouse_entered.connect(on_hover)

func on_back_pressed():
	click_sound.play()
	await click_sound.finished
	get_tree().change_scene_to_file("res://scenes/start_screen.tscn")

func on_hover():
	hover_sound.play()
