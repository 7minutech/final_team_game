extends Node2D

var location: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.global_position = location
	

func setLocation(l: Vector2):
	location = l
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !$Visibility.is_on_screen() and $Despawn.time_left <= 0:
		self.call_deferred("queue_free")

func _on_middle_spin_timeout() -> void:
	$Middle.rotate(deg_to_rad(-90))
	$Inner.rotate(deg_to_rad(-90))
	$Smallest.rotate(deg_to_rad(-90))
