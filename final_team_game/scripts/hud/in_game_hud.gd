extends Node2D

class_name Hud

### Constants ###
# Constants for preloads
const iconBG = preload("res://assets/hud/ability_icons/IconBG.png")

### Variables ###
# Variables for determining what screen to display
var choice: bool = false
var chest: bool = false
var isPaused: bool = false

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
	var sideLength: int = 50
	if PlayerObserver.player.abilities.has(ability) and ability_qty[ability] == 1:
		var path: String = AbilityObserver.ABILITY_ASSET_PATH.get(ability)
		var image = load(path)
		$AbilityIcons.add_image(image, sideLength, sideLength, Color(1,1,1), INLINE_ALIGNMENT_CENTER, Rect2(0,0,0, 0), null, false, "", false)
		$AbilityIconsBG.add_image(iconBG, sideLength, sideLength, Color(1,1,1), INLINE_ALIGNMENT_CENTER, Rect2(0,0,0, 0), null, false, "", false)
		$AbilityIcons.append_text("  ")
		$AbilityIconsBG.append_text("  ")
##
# Function to clear the ability label for redrawing
func clearAbilities() -> void:
	$AbilityIcons.clear()
	$AbilityIconBG.clear()
	

### Functions to pop-up screen logic ###
func setPaused() -> void:
	if isPaused:
		isPaused = false
	else:
		isPaused = true
##
func setChoice() -> void:
	if choice:
		choice = false
	else:
		choice = true
##
func setChest() -> void:
	if chest:
		chest = false
	else:
		chest = true
##


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
