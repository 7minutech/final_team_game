extends Node2D

## Variables
# Variables for time calculation
var startTime: float
var timeCheck: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	startTime = Time.get_unix_time_from_system()
	updateTime()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	

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
