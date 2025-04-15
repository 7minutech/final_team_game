extends Node2D

const iconBG = preload("res://icon.svg")
const image2 = preload("res://assets/hud/ability_symbols/filled_pip/AbilityPip_Filled.png")
const image3 = preload("res://assets/hud/ability_symbols/empty_pip/AbilityPip_Empty.png")
const message: String = "Pretyped Text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.f
func _process(_delta: float) -> void:
	if get_tree().paused && !self.is_visible():
		self.show()
		update_stats_label()
		addAbility(image2, "Image2")
		addAbility(image3, message)
		#print(PlayerObserver.toString())

# Function to add ability images to the label
func addAbility(image, tooltip: String) -> void:
	for i in range(4):
		$AbilityIcon.add_image(image, 50, 50, Color(1,1,1), INLINE_ALIGNMENT_CENTER, Rect2(0,0,0, 0), null, false, tooltip, false)
		$AbilityIconBG.add_image(iconBG, 50, 50, Color(1,1,1), INLINE_ALIGNMENT_CENTER)

# Function to update the current stats label	
func update_stats_label() -> void:
	var text: String = "Max Health: " + str(PlayerObserver.max_hp)
	text += "\nCurrent Health: " + str(PlayerObserver.current_hp)
	text += "\nPlayer Level: " + str(PlayerObserver.current_level)
	text += "\nMax XP: " + str(PlayerObserver.max_xp)
	text += "\nCurrent XP: " + str(PlayerObserver.current_xp)
	$StatsLabel.set_text(text)


func _on_resume_pressed() -> void:
	self.hide()
	get_tree().set_pause(false)
