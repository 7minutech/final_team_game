extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_tree().paused && get_parent().choice:
		self.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



### Functions for button pressed logic ###
func buttonPressed() -> void:
	pass
##
func _on_choice_1_pressed() -> void:
	pass # Replace with function body.
##
func _on_choice_2_pressed() -> void:
	pass # Replace with function body.
##
func _on_choice_3_pressed() -> void:
	pass # Replace with function body.
