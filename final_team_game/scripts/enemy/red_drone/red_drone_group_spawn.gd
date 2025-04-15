extends Node2D

### Constants ###
# Constants for preload
const group = preload("res://scenes/enemy/red_drone/red_drone_group.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_red_drone_group()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

### Functions for spawning logic ###
func spawn_red_drone_group() -> void:
	var g = group.instantiate()
	get_tree().current_scene.add_child(g)
	g.global_position = self.global_position


func _on_remove_self_timer_timeout() -> void:
	self.call_deferred("queue_free")
