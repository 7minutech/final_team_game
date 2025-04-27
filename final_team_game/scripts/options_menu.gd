extends Control

@onready var hover_sound = $HoverSound
@onready var click_sound = $ClickSound
@onready var back_button = $BackButton

func _ready():
	back_button.mouse_entered.connect(on_hover)

func _on_back_button_pressed() -> void:
	click_sound.play()
	await get_tree().create_timer(0.5)
	get_tree().change_scene_to_file("res://scenes/start_screen.tscn")

func on_hover():
	hover_sound.play()
