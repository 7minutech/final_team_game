extends Node2D

class_name Hud

### Constants ###
# Constants for preloads
const iconBG = preload("res://assets/hud/ability_icons/IconBG.png")

### Variables ###
# Variables for time calculation
var startTime: float
var timeCheck: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	startTime = Time.get_unix_time_from_system()
	updateTime()
	$KillCounter.set_text("0")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
### Functions to handle ability icon logic ###
# Function to add ability images to the ability label
func addAbility(ability: String) -> void:
	var ability_qty = PlayerObserver.player.ability_qty
	if PlayerObserver.player.abilities.has(ability) and ability_qty[ability] == 1:
		var path: String = AbilityObserver.ABILITY_ASSET_PATH.get(ability)
		var image = load(path)
		var numAbilities: int = PlayerObserver.player.abilities.size()
		if numAbilities < 4:
			$AbilityIcons.add_image(image, 50, 50, Color(1,1,1), INLINE_ALIGNMENT_CENTER, Rect2(0,0,0, 0), null, false, "", false)
			$AbilityIconsBG.add_image(iconBG, 50, 50, Color(1,1,1), INLINE_ALIGNMENT_CENTER, Rect2(0,0,0, 0), null, false, "", false)
			$AbilityIcons.append_text("  ")
			$AbilityIconsBG.append_text("  ")
		elif numAbilities == 5:
			$AbilityIcons.add_image(image, 50, 50, Color(1,1,1), INLINE_ALIGNMENT_CENTER, Rect2(0,0,0, 0), null, false, "", false)
			$AbilityIconsBG.add_image(iconBG, 50, 50, Color(1,1,1), INLINE_ALIGNMENT_CENTER, Rect2(0,0,0, 0), null, false, "", false)
			$AbilityIcons.append_text("  ")
			$AbilityIconsBG.append_text("  ")
		elif numAbilities < 8:
			$AbilityIcons.add_image(image, 50, 50, Color(1,1,1), INLINE_ALIGNMENT_CENTER, Rect2(0,0,0, 0), null, false, "", false)
			$AbilityIconsBG.add_image(iconBG, 50, 50, Color(1,1,1), INLINE_ALIGNMENT_CENTER, Rect2(0,0,0, 0), null, false, "", false)
			$AbilityIcons.append_text("  ")
			$AbilityIconsBG.append_text("  ")
##
# Function to clear the ability label for redrawing
func clearAbilities() -> void:
	$AbilityIcons.clear()
	$AbilityIconBG.clear()
	

### Functions to handle kill label logic ###

### Functions to handle time label logic ###
# Function to get current time
func getTime() -> void:
	timeCheck = Time.get_unix_time_from_system()
##
# Function to determine the time since the start and convert it to usable text
func convertTime() -> String:
	var subtractedTime: float = timeCheck - startTime
	var dict: Dictionary = Time.get_time_dict_from_unix_time(subtractedTime)
	var minute = dict.get("minute")
	var sec = dict.get("second")
	if minute < 10:
		if sec < 10:
			return str(0) + str(minute) + ":" + str(0) + str(sec)
		else:
			return str(0) + str(minute) + ":" + str(sec)
	else:
		if sec < 10:
			return str(minute) + ":" + str(0) + str(sec)
		else:
			return str(minute) + ":" + str(sec)
##
# Function to update the TimeLabel
func updateTime() -> void:
	getTime()
	$TimeLabel.set_text(convertTime())
##
# Function to update the TimeLabel every second
func _on_update_time_label_timeout() -> void:
	updateTime()
	TimeObserver.addOneToTotalTime()
