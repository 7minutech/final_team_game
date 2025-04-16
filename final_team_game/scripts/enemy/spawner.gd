extends Node2D

class_name Spawner

@onready var pos: Marker2D = $Marker2D
var entity_dict: Dictionary = {
	"robot": "res://scenes/enemy/enemy_1.tscn",
 	"blue_drone": "res://scenes/enemy/blue_drone.tscn",
	"braizer": "res://scenes/item/braizer.tscn",
	"robot_boss": "res://scenes/enemy/robot_boss.tscn",
	"alien": "res://scenes/enemy/alien.tscn",
	"red_drones": "res://scenes/enemy/red_drone/red_drone_group.tscn",
	"bullet_turret": "res://scenes/enemy/bullet_turret/bullet_turret.tscn"
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
	get_tree().current_scene.add_child(new_spawn)
	new_spawn.global_position = CameraObserver.get_random_spawn_position()

func spawn_with_position(entity_key: String, spawn_position: Vector2):
	var new_spawn_scene = load(entity_dict[entity_key])
	var new_spawn = new_spawn_scene.instantiate()
	get_tree().current_scene.add_child(new_spawn)
	new_spawn.global_position = spawn_position

func spawn_ring_aliens(num_aliens:int):
	#equation for circle (x - h)² + (y - k)² = r² 
	var player_position = PlayerObserver.player.position
	var offset: float = 0
	var right_camera_position: Vector2 = CameraObserver.get_spawn_right(offset)

	var center_of_circle = player_position
	var h: float = center_of_circle.x
	var k: float = center_of_circle.y
	var radius: float = right_camera_position.x - player_position.x
		
	for i in range(num_aliens):
		var angle = (TAU / num_aliens) * i  # TAU = 2 * PI
		var x = h + radius * cos(angle)
		var y = k + radius * sin(angle)
		var point = Vector2(x, y)
		spawn_with_position("alien", point)
