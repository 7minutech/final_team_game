extends Node

## Variables
var total_time: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# Function to increase total_time by one
func addOneToTotalTime() -> void:
	total_time += 1
