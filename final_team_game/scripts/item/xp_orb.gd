extends Sprite2D

class_name XPOrb

var xp_value: int = 10
var picked_up: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.

func player_pick_up() -> void:
	queue_free()
	pass

func xp_orb() -> void:
	pass
	
func set_xp_value(value: int) -> void:
	xp_value = value

func set_picked_up(value: bool) -> void:
	picked_up = value
	
