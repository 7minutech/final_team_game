extends Node2D

const TOP: int = 1
const BOTTOM: int = 2
const RIGHT: int = 3
const LEFT: int = 4
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("spawn"):
		spawn_enemies()
	pass


func spawn_enemies():
	var spawner: Spawner = $Spawner
	var random_number = randi_range(1, 4)
	var camera_edges: Dictionary = get_camera_edges($Hero/HeroCamera)
	var offset: float = randf_range(-500.0, 500.0)
	match random_number:	
		TOP:
			spawner.spawn_robot(get_spawn_top(camera_edges, offset))
		BOTTOM:
			spawner.spawn_robot(get_spawn_bottom(camera_edges, offset))
		RIGHT:
			spawner.spawn_robot(get_spawn_right(camera_edges, offset))
		LEFT:
			spawner.spawn_robot(get_spawn_left(camera_edges, offset))
	pass

func get_camera_edges(camera: Camera2D) -> Dictionary:
	var viewport_size = get_viewport().get_visible_rect().size
	var zoom = camera.zoom
	var half_width = (viewport_size.x * 0.5) * zoom.x
	var half_height = (viewport_size.y * 0.5) * zoom.y
	
	var cam_pos = camera.global_position

	return {
		"left": cam_pos.x - half_width,
		"right": cam_pos.x + half_width,
		"top": cam_pos.y - half_height,
		"bottom": cam_pos.y + half_height
	}

func get_spawn_left(camera_positions: Dictionary, offset: float) -> Vector2:
	var x_pos: float = camera_positions["left"]
	var y_pos: float = PlayerObserver.player.position.y + offset
	return Vector2(x_pos, y_pos)
	pass
	
func get_spawn_right(camera_positions: Dictionary, offset: float) -> Vector2:
	var x_pos: float = camera_positions["right"]
	var y_pos: float = PlayerObserver.player.position.y + offset
	return Vector2(x_pos, y_pos)
	pass

func get_spawn_top(camera_positions: Dictionary, offset: float) -> Vector2:
	var x_pos: float = PlayerObserver.player.position.x + offset
	var y_pos: float = camera_positions["top"]
	return Vector2(x_pos, y_pos)
	pass
	
func get_spawn_bottom(camera_positions: Dictionary, offset: float) -> Vector2:
	var x_pos: float = PlayerObserver.player.position.x + offset
	var y_pos: float = camera_positions["bottom"]
	return Vector2(x_pos, y_pos)
	pass

func _on_enemy_spawn_timer_timeout() -> void:
	spawn_enemies()
	pass # Replace with function body.
