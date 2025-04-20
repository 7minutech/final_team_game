extends Area2D


var multiplier: float = 10.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is Player:
		set_pitch_scale()
		$PickUpSound.play()
		var player: Player = parent
		var tween = create_tween()
		tween.tween_property(self, "global_position", player.global_position, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.connect("finished", Callable(self, "_on_tween_finished").bind(player))

func _on_tween_finished(player: Player) -> void:
	player.give_magnet_pickup(multiplier)
	queue_free()

func set_pitch_scale() -> void:
	var pitch := randf_range(0.9,1.1)
	$PickUpSound.pitch_scale = pitch
