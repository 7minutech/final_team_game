extends Node2D

### Constants ###

### Variables ###
@onready var spawner: Spawner = get_tree().current_scene.find_child("Spawner")
var show_spawners: bool = false
var show_cheats: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Show_Hide_Spawners.set_text("Show Spawner Menu")
	show_spawners = false
	$SpawnerMenu.hide()
	$Show_Hide_Cheats.set_text("Show Cheats Menu")
	show_cheats = false
	$CheatsMenu.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

### Functions for debug menu logic ###
func _on_show_hide_debug_pressed() -> void:
	$ClickSound.play()  # Play the click sound
	if show_spawners:
		$Show_Hide_Spawners.set_text("Show Spawner Menu")
		$SpawnerMenu.hide()
		show_spawners = false
	elif show_cheats:
		# Hide cheats menu and adjust cheat menu button text
		$Show_Hide_Cheats.set_text("Show Cheats Menu")
		$CheatsMenu.hide()
		show_cheats = false
		# Show spawner menu and adjust spawner menu button text
		$Show_Hide_Spawners.set_text("Hide Spawner Menu")
		$SpawnerMenu.show()
		show_spawners = true
	else:
		$Show_Hide_Spawners.set_text("Hide Spawner Menu")
		$SpawnerMenu.show()
		show_spawners = true

func _on_spawn_robot_pressed() -> void:
	$ClickSound.play()  # Play the click sound
	spawner.spawn("robot")

func _on_spawn_robot_boss_pressed() -> void:
	$ClickSound.play()  # Play the click sound
	spawner.spawn("robot_boss")

func _on_spawn_alien_pressed() -> void:
	$ClickSound.play()  # Play the click sound
	spawner.spawn("alien")

func _on_spawn_alien_ring_pressed() -> void:
	$ClickSound.play()  # Play the click sound
	spawner.spawn_ring_aliens(60)

func _on_spawn_blue_drone_pressed() -> void:
	$ClickSound.play()  # Play the click sound
	spawner.spawn("blue_drone")

func _on_spawn_red_drone_group_pressed() -> void:
	$ClickSound.play()  # Play the click sound
	spawner.spawn("red_drones")

func _on_spawn_turret_pressed() -> void:
	$ClickSound.play()  # Play the click sound
	spawner.spawn("bullet_turret")

### Functions for cheats menu logic ###
func _on_show_hide_cheats_pressed() -> void:
	$ClickSound.play()  # Play the click sound
	if show_cheats:
		$Show_Hide_Cheats.set_text("Show Cheats Menu")
		$CheatsMenu.hide()
		show_cheats = false
	elif show_spawners:
		# Hide spawner menu and adjust spawner menu button text
		$Show_Hide_Spawners.set_text("Show Spawner Menu")
		$SpawnerMenu.hide()
		show_spawners = false
		# Show cheats menu and adjust cheats menu button text
		$Show_Hide_Cheats.set_text("Hide Cheats Menu")
		$CheatsMenu.show()
		show_cheats = true
	else:
		$Show_Hide_Cheats.set_text("Hide Cheats Menu")
		$CheatsMenu.show()
		show_cheats = true

func _on_invincibility_pressed() -> void:
	$ClickSound.play()  # Play the click sound
	var player = PlayerObserver.player
	if player.invincible == false:
		player.invincible = true
	else:
		player.invincible = false

func _on_level_up_pressed() -> void:
	$ClickSound.play()  # Play the click sound
	var player = PlayerObserver.player
	player.level_up()

func _on_spawn_drone_boss_pressed() -> void:
	$ClickSound.play()  # Play the click sound
	spawner.spawn("blue_drone_boss")

func _on_give_coins_pressed() -> void:
	$ClickSound.play()  # Play the click sound
	PlayerObserver.coins += 30
