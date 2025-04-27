extends HSlider

@export var bus_name: String

var bus_index


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)
	value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	pass # Replace with function body.
