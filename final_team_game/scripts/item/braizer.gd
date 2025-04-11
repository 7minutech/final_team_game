extends Area2D

class_name Braizer

var drop_item_scene: PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func get_xp_orb_scene() -> PackedScene:
	return preload("res://scenes/item/xp_orb.tscn")

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("bullet"):
		var xp_orb_instance: XPOrb2 = get_xp_orb_scene().instantiate()
		xp_orb_instance.global_position = self.global_position
		get_tree().current_scene.add_child(xp_orb_instance)
		queue_free()
	pass # Replace with function body.
