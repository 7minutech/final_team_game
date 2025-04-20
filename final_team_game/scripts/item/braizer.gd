extends Area2D

class_name Braizer

var drop_item_scene: PackedScene
var items: Dictionary = {
	"health": load("res://scenes/item/health_pickup.tscn")
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Reward.play("rotation")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func get_xp_orb_scene() -> PackedScene:
	return preload("res://scenes/item/xp_orb.tscn")

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("bullet"):
		var item_instance = get_random_item().instantiate()
		item_instance.global_position = self.global_position
		get_tree().current_scene.add_child(item_instance)
		queue_free()
	pass # Replace with function body.

func get_random_item() -> PackedScene:
	var keys = items.keys()
	var random_key = keys[randi() % keys.size()]
	return items[random_key]
