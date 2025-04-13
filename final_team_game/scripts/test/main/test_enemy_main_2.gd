extends Node2D


@onready var spawner: Spawner = $Spawner
@export var spawn_robots: bool = true
@export var spawn_braizers: bool = true
@export var spawn_robot_boss: bool = true
@export var spawn_drones: bool = true
@export var spawn_alien: bool = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#test
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:	
	if Input.is_action_just_pressed("spawn"):
		spawner.spawn("robot_boss")
		#spawner.spawn_ring_aliens(60)


func _on_enemy_spawn_timer_timeout() -> void:
	if spawn_robots:
		spawner.spawn("robot")

func _on_braizer_spawn_timer_timeout() -> void:
	if spawn_braizers:
		spawner.spawn("braizer")
	pass # Replace with function body.

func _on_blue_drone_timer_timeout() -> void:
	if spawn_drones:
		spawner.spawn("blue_drone")

func _on_robot_boss_timer_timeout() -> void:
	if spawn_robot_boss:
		spawner.spawn("robot_boss")
	pass # Replace with function body.


func _on_alien_timer_timeout() -> void:
	if spawn_alien:
		spawner.spawn("alien")
	pass # Replace with function body.


func _on_spawn_robot_pressed() -> void:
	spawner.spawn("robot")
	pass # Replace with function body.


func _on_spawn_robot_boss_pressed() -> void:
	spawner.spawn("robot_boss")
	pass # Replace with function body.

func _on_spawn_alien_pressed() -> void:
	spawner.spawn("alien")
	pass # Replace with function body.


func _on_spawn_ring_alien_pressed() -> void:
	spawner.spawn_ring_aliens(60)
	pass # Replace with function body.


func _on_hide_button_pressed() -> void:
	var hide_button: Button = $CanvasLayer/HideButton
	var buttons = $CanvasLayer.get_children()
	if hide_button.text == "Hide":
		for button: Button in buttons:
			if button != hide_button:
				button.hide()
	else:
		for button: Button in buttons:
			button.show()	
	if hide_button.text == "Hide":
		hide_button.text = "Show"
	else:
		hide_button.text = "Hide"
	pass # Replace with function body.


func _on_spawn_blue_drone_pressed() -> void:
	spawner.spawn("blue_drone")
	pass # Replace with function body.


func _on_ring_alien_timer_timeout() -> void:
	spawner.spawn_ring_aliens(60)
	pass # Replace with function body.
