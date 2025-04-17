extends Node2D

### Constants ###
const iconBG = preload("res://icon.svg")
const image2 = preload("res://assets/hud/ability_tracking_symbols/filled_pip/AbilityPip_Filled.png")
const image3 = preload("res://assets/hud/ability_tracking_symbols/empty_pip/AbilityPip_Empty.png")
const message: String = "Pretyped Text"

### Variables ###
var numAbilities: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.f
func _process(_delta: float) -> void:
	if get_tree().paused && !self.is_visible():
		self.show()
		get_parent().find_child("AbilityIcons").hide()
		get_parent().find_child("AbilityIconsBG").hide()
		update_stats_label()
		clearAbilities()
		addAbilities()
		#print(PlayerObserver.toString())


# Function to add ability images to the ability label
func addAbilities() -> void:
	var player = AbilityObserver.player
	for key in player.abilities:
		var path: String = AbilityObserver.ABILITY_ASSET_PATH.get(key)
		var image = load(path)
		var tooltip: String = AbilityObserver.ABILITY_DESCRIPTIONS.get(key)
		if numAbilities < 4:
			$AbilityIcon_Top.add_image(image, 50, 50, Color(1,1,1), INLINE_ALIGNMENT_CENTER, Rect2(0,0,0, 0), null, false, tooltip, false)
			$AbilityIconBG_Top.add_image(iconBG, 50, 50, Color(1,1,1), INLINE_ALIGNMENT_CENTER, Rect2(0,0,0, 0), null, false, tooltip, false)
			$AbilityIcon_Top.append_text("  ")
			$AbilityIconBG_Top.append_text("  ")
		elif numAbilities < 8:
			$AbilityIcon_Bottom.add_image(image, 50, 50, Color(1,1,1), INLINE_ALIGNMENT_CENTER, Rect2(0,0,0, 0), null, false, tooltip, false)
			$AbilityIconBG_Bottom.add_image(iconBG, 50, 50, Color(1,1,1), INLINE_ALIGNMENT_CENTER, Rect2(0,0,0, 0), null, false, tooltip, false)
			$AbilityIcon_Bottom.append_text("  ")
			$AbilityIconBG_Bottom.append_text("  ")
		numAbilities += 1
	numAbilities = 0

# Function to clear the ability label for redrawing
func clearAbilities() -> void:
	$AbilityIcon_Top.clear()
	$AbilityIconBG_Top.clear()
	$AbilityIcon_Bottom.clear()
	$AbilityIconBG_Bottom.clear()

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
	get_parent().find_child("AbilityIcons").show()
	get_parent().find_child("AbilityIconsBG").show()
	get_tree().set_pause(false)
