extends Label

class_name DamageLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func show_hit_number(dmg: int) -> void:
	$AnimationPlayer2.play("hit")
	text = str(dmg)
	show()
	await get_tree().create_timer(0.2).timeout
	hide()
