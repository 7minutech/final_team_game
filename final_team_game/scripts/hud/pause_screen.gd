extends Node2D

### Constants ###
const ICON_BG = preload("res://assets/hud/ability_icons/IconBG.png")
const FILLED_PIP = preload("res://assets/hud/ability_tracking_symbols/filled_pip/AbilityPip_Filled.png")
const EMPTY_PIP = preload("res://assets/hud/ability_tracking_symbols/empty_pip/AbilityPip_Empty.png")
const MESSAGE: String = "Pretyped Text"

### Variables ###
var numAbilities: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.f
func _process(_delta: float) -> void:
	if get_tree().paused && get_parent().isPaused && !self.is_visible():
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
		numAbilities += 1
		var path: String = AbilityObserver.ABILITY_ASSET_PATH.get(key)
		var image = load(path)
		var maxQTY: int = AbilityObserver.MAX_ABILITY_QTY.get(key)
		var currentQTY: int = AbilityObserver.player.ability_qty.get(key)
		var tooltip: String = AbilityObserver.ABILITY_DESCRIPTIONS.get(key)
		var empty: String = "EmptyPips_" + str(numAbilities)
		var full: String = "FilledPips_" + str(numAbilities)
		if numAbilities < 5:
			var top: bool = true
			placeIcons(top, image, tooltip, empty, full, currentQTY, maxQTY)

		elif numAbilities < 9:
			var top: bool = false
			placeIcons(top, image, tooltip, empty, full, currentQTY, maxQTY)

	numAbilities = 0

# Function to clear the ability label for redrawing
func clearAbilities() -> void:
	$AbilityIcon_Top.clear()
	$AbilityIconBG_Top.clear()
	$AbilityIcon_Bottom.clear()
	$AbilityIconBG_Bottom.clear()
	var count = 1
	for i: int in range(AbilityObserver.player.abilities.size()):
		if count < 9:
			var empty: String = "EmptyPips_" + str(count)
			var filled: String = "FilledPips_" + str(count)
			self.find_child(empty).clear()
			self.find_child(filled).clear()
			count += 1
# Function to place the correct components on the ability label
func placeIcons(top: bool, image: Texture2D, tooltip: String, emptyNodeName: String, filledNodeName: String, currentQTY: int, maxQTY: int) -> void:
	var pipSideLength: int = 17
	var iconSideLength: int = 50
	if top:
		$AbilityIcon_Top.add_image(image, iconSideLength, iconSideLength, Color(1,1,1), INLINE_ALIGNMENT_CENTER, Rect2(0,0,0, 0), null, false, tooltip, false)
		$AbilityIconBG_Top.add_image(ICON_BG, iconSideLength, iconSideLength, Color(1,1,1), INLINE_ALIGNMENT_CENTER, Rect2(0,0,0, 0), null, false, tooltip, false)
		$AbilityIcon_Top.append_text("  ")
		$AbilityIconBG_Top.append_text("  ")
	else:
		$AbilityIcon_Bottom.add_image(image, iconSideLength, iconSideLength, Color(1,1,1), INLINE_ALIGNMENT_CENTER, Rect2(0,0,0, 0), null, false, tooltip, false)
		$AbilityIconBG_Bottom.add_image(ICON_BG, iconSideLength, iconSideLength, Color(1,1,1), INLINE_ALIGNMENT_CENTER, Rect2(0,0,0, 0), null, false, tooltip, false)
		$AbilityIcon_Bottom.append_text("  ")
		$AbilityIconBG_Bottom.append_text("  ")
	for i in range(maxQTY):
		self.find_child(emptyNodeName).add_image(EMPTY_PIP, pipSideLength, pipSideLength, Color(1,1,1), INLINE_ALIGNMENT_CENTER, Rect2(0,0,0, 0), null, false, "", false)
	for i in range(currentQTY):
		self.find_child(filledNodeName).add_image(FILLED_PIP, pipSideLength, pipSideLength, Color(1,1,1), INLINE_ALIGNMENT_CENTER, Rect2(0,0,0, 0), null, false, "", false)

# Function to update the current stats label	
func update_stats_label() -> void:
	var text: String = "Max Health: " + str(PlayerObserver.max_hp)
	text += "\nCurrent Health: " + str(PlayerObserver.current_hp)
	text += "\nPlayer Level: " + str(PlayerObserver.current_level)
	text += "\nMax XP: " + str(PlayerObserver.max_xp)
	text += "\nCurrent XP: " + str(PlayerObserver.current_xp)
	$StatsLabel.set_text(text)


func _on_resume_pressed() -> void:
	get_parent().setPaused()
	self.hide()
	get_parent().find_child("AbilityIcons").show()
	get_parent().find_child("AbilityIconsBG").show()
	get_tree().set_pause(false)
