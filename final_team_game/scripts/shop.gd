extends Control

@onready var hover_sound = $HoverSound
@onready var click_sound = $ClickSound
@onready var back_button = $BackButton

enum upgrade_type { AVAILABLE, ON, OFF }

func _ready():
	var coins: int = PlayerObserver.coins
	$CoinLabel.text = "Coins: " + str(coins)
	
	back_button.pressed.connect(on_back_pressed)
	back_button.mouse_entered.connect(on_hover)

	var upgrade_1 = PlayerObserver.permanent_upgrade["xp"]
	var upgrade_2 = PlayerObserver.permanent_upgrade["pizza"]
	var upgrade_3 = PlayerObserver.permanent_upgrade["music"]

	_update_button_status($UpgradeList/Upgrade1/PurchaseButton1, upgrade_1)
	_update_button_status($UpgradeList/Upgrade2/PurchaseButton2, upgrade_2)
	_update_button_status($UpgradeList/Upgrade3/PurchaseButton3, upgrade_3)


func on_back_pressed():
	click_sound.play()
	await click_sound.finished
	get_tree().change_scene_to_file("res://scenes/start_screen.tscn")


func on_hover():
	hover_sound.play()


# Helper function to update the button text and color based on upgrade status
# Helper function to update the button text and color based on upgrade status
func _update_button_status(button: Button, upgrade_status: int):
	if upgrade_status == upgrade_type.AVAILABLE:
		button.text = "Purchase (30 coins)"
		button.modulate = Color(1, 0.84, 0)  # Gold color for Available state
	elif upgrade_status == upgrade_type.OFF:
		button.text = "Off"  # Button text indicates what will happen when pressed
		button.modulate = Color(1, 0, 0)  # Red color for Off state
	else:  # upgrade_type.ON
		button.text = "On"  # Button text indicates what will happen when pressed
		button.modulate = Color(0, 1, 0)  # Green color for On state

# Handle purchase and toggling for Upgrade 1
func _on_purchase_button_1_pressed() -> void:
	var upgrade = PlayerObserver.permanent_upgrade["xp"]
	$ClickSound.play()
	
	if PlayerObserver.coins >= 30 and upgrade == upgrade_type.AVAILABLE:
		# Purchase the upgrade and set it to ON
		PlayerObserver.coins -= 30
		PlayerObserver.permanent_upgrade["xp"] = upgrade_type.ON
		# Since the upgrade is now ON, the button should say "Off" to indicate 
		# clicking it will turn the upgrade off
		$UpgradeList/Upgrade1/PurchaseButton1.text = "On"
		$UpgradeList/Upgrade1/PurchaseButton1.modulate = Color(0, 1, 0)  # Green color for ON state
	elif upgrade == upgrade_type.ON:
		# If the upgrade is ON, toggle it to OFF
		PlayerObserver.permanent_upgrade["xp"] = upgrade_type.OFF
		# Since the upgrade is now OFF, the button should say "On" to indicate 
		# clicking it will turn the upgrade on
		$UpgradeList/Upgrade1/PurchaseButton1.text = "Off"
		$UpgradeList/Upgrade1/PurchaseButton1.modulate = Color(1, 0, 0)  # Red color for OFF state
	elif upgrade == upgrade_type.OFF:
		# If the upgrade is OFF, toggle it to ON
		PlayerObserver.permanent_upgrade["xp"] = upgrade_type.ON
		# Since the upgrade is now ON, the button should say "Off" to indicate 
		# clicking it will turn the upgrade off
		$UpgradeList/Upgrade1/PurchaseButton1.text = "On"
		$UpgradeList/Upgrade1/PurchaseButton1.modulate = Color(0, 1, 0)  # Green color for ON state

	$CoinLabel.text = "Coins: " + str(PlayerObserver.coins)

# Handle purchase and toggling for Upgrade 2
func _on_purchase_button_2_pressed() -> void:
	var upgrade = PlayerObserver.permanent_upgrade["pizza"]
	$ClickSound.play()
	if PlayerObserver.coins >= 30 and upgrade == upgrade_type.AVAILABLE:
		# Purchase the upgrade and set it to ON
		PlayerObserver.coins -= 30
		PlayerObserver.permanent_upgrade["pizza"] = upgrade_type.ON
		$UpgradeList/Upgrade2/PurchaseButton2.text = "On"
		$UpgradeList/Upgrade2/PurchaseButton2.modulate = Color(0, 1, 0)  # Green color for ON state
	elif upgrade == upgrade_type.ON:
		# If the upgrade is ON, toggle it to OFF
		PlayerObserver.permanent_upgrade["pizza"] = upgrade_type.OFF
		$UpgradeList/Upgrade2/PurchaseButton2.text = "Off"
		$UpgradeList/Upgrade2/PurchaseButton2.modulate = Color(1, 0, 0)  # Red color for OFF state
	elif upgrade == upgrade_type.OFF:
		# If the upgrade is OFF, toggle it to ON
		PlayerObserver.permanent_upgrade["pizza"] = upgrade_type.ON
		$UpgradeList/Upgrade2/PurchaseButton2.text = "On"
		$UpgradeList/Upgrade2/PurchaseButton2.modulate = Color(0, 1, 0)  # Green color for ON state

	$CoinLabel.text = "Coins: " + str(PlayerObserver.coins)

# Handle purchase and toggling for Upgrade 3
func _on_purchase_button_3_pressed() -> void:
	var upgrade = PlayerObserver.permanent_upgrade["music"]
	$ClickSound.play()
	if PlayerObserver.coins >= 30 and upgrade == upgrade_type.AVAILABLE:
		# Purchase the upgrade and set it to ON
		PlayerObserver.coins -= 30
		PlayerObserver.permanent_upgrade["music"] = upgrade_type.ON
		$UpgradeList/Upgrade3/PurchaseButton3.text = "On"
		$UpgradeList/Upgrade3/PurchaseButton3.modulate = Color(0, 1, 0)  # Green color for ON state
	elif upgrade == upgrade_type.ON:
		# If the upgrade is ON, toggle it to OFF
		PlayerObserver.permanent_upgrade["music"] = upgrade_type.OFF
		$UpgradeList/Upgrade3/PurchaseButton3.text = "Off"
		$UpgradeList/Upgrade3/PurchaseButton3.modulate = Color(1, 0, 0)  # Red color for OFF state
	elif upgrade == upgrade_type.OFF:
		# If the upgrade is OFF, toggle it to ON
		PlayerObserver.permanent_upgrade["music"] = upgrade_type.ON
		$UpgradeList/Upgrade3/PurchaseButton3.text = "On"
		$UpgradeList/Upgrade3/PurchaseButton3.modulate = Color(0, 1, 0)  # Green color for ON state

	$CoinLabel.text = "Coins: " + str(PlayerObserver.coins)
