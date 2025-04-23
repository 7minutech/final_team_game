extends Sprite2D
class_name Arrow
var target_node: Node2D = null
var offset_from_player := Vector2(0, -85)  # 75 pixels above player's head
var current_direction: String = ""

func _process(delta: float) -> void:
	if not target_node or not is_instance_valid(target_node):
		hide()
		return
	
	var player = get_parent() 
	global_position = player.global_position + offset_from_player
	
	var direction = target_node.global_position - global_position
	
	# Subtract PI/2 because the sprite points down by default
	rotation = direction.angle() - PI/2
	
	# Determine cardinal direction
	var angle_degrees = rad_to_deg(direction.angle())
	
	# Normalize angle to 0-360 range
	if angle_degrees < 0:
		angle_degrees += 360
	
	# Determine direction based on angle
	if angle_degrees >= 315 or angle_degrees < 45:
		current_direction = "right"
		$AnimationPlayer.play("point_right")
	elif angle_degrees >= 45 and angle_degrees < 135:
		current_direction = "down"
		$AnimationPlayer.play("point_down")
	elif angle_degrees >= 135 and angle_degrees < 225:
		current_direction = "left"
		$AnimationPlayer.play("point_left")
	else:  # angle_degrees >= 225 and angle_degrees < 315
		current_direction = "up"
		$AnimationPlayer.play("point_up")
	
	# You can use the current_direction value for different behaviors
	# print("Arrow is pointing: " + current_direction)
	
	show()

func set_target_node(target: Node2D) -> void:
	target_node = target

func get_current_direction() -> String:
	return current_direction
