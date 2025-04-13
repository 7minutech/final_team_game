extends Node2D

class_name Spawner

@onready var pos: Marker2D = $Marker2D
var entity_dict: Dictionary = {
	"robot": "res://scenes/enemy/enemy_1.tscn",
 	"blue_drone": "res://scenes/enemy/blue_drone.tscn",
	"braizer": "res://scenes/item/braizer.tscn",
	"robot_boss": "res://scenes/enemy/robot_boss.tscn",
	"alien": "res://scenes/enemy/alien.tscn"
	}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#if Input.is_action_just_pressed("spawn"):
		#spawn(enemy, pos)
	pass

func spawn(entity_key: String):
	var new_spawn_scene = load(entity_dict[entity_key])
	var new_spawn = new_spawn_scene.instantiate()
	add_child(new_spawn)
	new_spawn.global_position = CameraObserver.get_random_spawn_position()

func spawn_ring_aliens():
	pass
