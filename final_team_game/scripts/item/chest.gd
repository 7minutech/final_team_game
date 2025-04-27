extends Area2D

class_name Chest

var arrow_scene = preload("res://scenes/item/arrow.tscn")
var arrow_instance: Arrow 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	arrow_instance = arrow_scene.instantiate()
	arrow_instance.set_target_node(self)
	if not $VisibleOnScreenEnabler2D.is_on_screen():
		PlayerObserver.player.add_child(arrow_instance)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	pass

func _on_area_entered(area: Area2D) -> void:
	if area.name == "ChestArea":
		var parent = area.get_parent()
		var arrow = parent.get_node("Arrow")
		if parent is Player and not get_tree().paused:
			if arrow != null:
				arrow.queue_free()
			set_pitch_scale()
			print("Player got a chest")
			PlayerObserver.player.find_child("Hud").setChest()
			get_tree().set_pause(true)
			await get_tree().create_timer(0.25).timeout
			queue_free()
		


func set_pitch_scale() -> void:
	var pitch := randf_range(0.9,1.1)
	$PickUpSound.pitch_scale = pitch


func _on_visible_on_screen_enabler_2d_screen_entered() -> void:

	if arrow_instance and arrow_instance.get_parent() != null:
		arrow_instance.queue_free()
	pass # Replace with function body.


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	if not is_instance_valid(arrow_instance):
		arrow_instance = arrow_scene.instantiate()
		arrow_instance.set_target_node(self)
		PlayerObserver.player.add_child(arrow_instance)
