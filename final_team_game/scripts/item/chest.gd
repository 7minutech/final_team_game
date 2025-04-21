extends Area2D
	
class_name Chest
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is Player:
		set_pitch_scale()
		$PickUpSound.play()
		print("Player got a chest")
		PlayerObserver.player.find_child("Hud").setChest()
		get_tree().set_pause(true)
		await get_tree().create_timer(0.25).timeout	
		queue_free()


func set_pitch_scale() -> void:
	var pitch := randf_range(0.9,1.1)
	$PickUpSound.pitch_scale = pitch
