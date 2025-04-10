extends Node2D

class_name Spawner

@onready var pos: Marker2D = $Marker2D
var enemy = preload("res://scenes/enemy/enemy_1.tscn")
var braizer = preload("res://scenes/item/braizer.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#if Input.is_action_just_pressed("spawn"):
		#spawn(enemy, pos)
	pass

func spawn(spawn_type , spawn_position):
	var new_spawn: CharacterBody2D = spawn_type.instantiate()
	add_child(new_spawn)
	new_spawn.global_position = spawn_position.global_position

func spawn_robot(spawn_position):
	var new_spawn: CharacterBody2D = enemy.instantiate()
	get_tree().current_scene.call_deferred("add_child", new_spawn)
	if !new_spawn.is_inside_tree():
		await new_spawn.tree_entered
	new_spawn.global_position = spawn_position

func spawn_braizer(spawn_position):
	var new_braizer: Braizer = braizer.instantiate()
	get_tree().current_scene.add_child(new_braizer)
	new_braizer.global_position = spawn_position
	

func _on_spawn_timer_timeout() -> void:
	pass # Replace with function body.
