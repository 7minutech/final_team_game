extends Node

const TOP: int = 1
const BOTTOM: int = 2
const RIGHT: int = 3
const LEFT: int = 4

var player_camera: Camera2D
var camera_positions: Dictionary
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	camera_positions = get_camera_edges(player_camera)

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

func get_spawn_left(offset: float) -> Vector2:
	var x_pos: float = camera_positions["left"]
	var y_pos: float = PlayerObserver.player.position.y + offset
	return Vector2(x_pos, y_pos)
	
func get_spawn_right(offset: float) -> Vector2:
	var x_pos: float = camera_positions["right"]
	var y_pos: float = PlayerObserver.player.position.y + offset
	return Vector2(x_pos, y_pos)

func get_spawn_top(offset: float) -> Vector2:
	var x_pos: float = PlayerObserver.player.position.x + offset
	var y_pos: float = camera_positions["top"]
	return Vector2(x_pos, y_pos)
	
func get_spawn_bottom(offset: float) -> Vector2:
	var x_pos: float = PlayerObserver.player.position.x + offset
	var y_pos: float = camera_positions["bottom"]
	return Vector2(x_pos, y_pos)

func get_spawn_left_offscreen(offset: float, offset_offscreen: float) -> Vector2:
	var x_pos: float = camera_positions["left"] - offset_offscreen
	var y_pos: float = PlayerObserver.player.position.y + offset
	return Vector2(x_pos, y_pos)
	
func get_spawn_right_offscreen(offset: float, offset_offscreen) -> Vector2:
	var x_pos: float = camera_positions["right"] + offset_offscreen
	var y_pos: float = PlayerObserver.player.position.y + offset
	return Vector2(x_pos, y_pos)

func get_spawn_top_offscreen(offset: float, offset_offscreen) -> Vector2:
	var x_pos: float = PlayerObserver.player.position.x + offset
	var y_pos: float = camera_positions["top"] - offset_offscreen
	return Vector2(x_pos, y_pos)
	
func get_spawn_bottom_offscreen(offset: float, offset_offscreen) -> Vector2:
	var x_pos: float = PlayerObserver.player.position.x + offset
	var y_pos: float = camera_positions["bottom"] + offset_offscreen
	return Vector2(x_pos, y_pos)

func get_random_spawn_position() -> Vector2:
	var random_number = randi_range(1, 4)
	var offset: float = randf_range(-500.0, 500.0)
	match random_number:	
		TOP:
			return (get_spawn_top(offset))
		BOTTOM:
			return (get_spawn_bottom(offset))
		RIGHT:
			return (get_spawn_right(offset))
		LEFT:
			return (get_spawn_left(offset))
		_:
			print("No match found for spawn location")
			return Vector2.ZERO
