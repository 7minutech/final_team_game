extends Node


var ability_path:Dictionary = {
	"garlic": "res://scenes/ability/passive/garlic.tscn"
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_ability_path(key):
	return ability_path[key]
