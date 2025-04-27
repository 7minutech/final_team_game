extends Control

@onready var hover_sound = $HoverSound
@onready var click_sound = $ClickSound
@onready var back_button = $BackButton

func _ready():
	back_button.pressed.connect(on_back_pressed)
	back_button.mouse_entered.connect(on_hover)

func on_back_pressed():
	click_sound.play()
	await get_tree().create_timer(0.5)
	get_tree().change_scene_to_file("res://scenes/start_screen.tscn")

func on_hover():
	hover_sound.play()


func _on_purchase_button_1_pressed() -> void:
	if PlayerObserver.coins >= 100:
		PlayerObserver.coins -= 100
		$CoinLabel.text = "Coins: " + str(PlayerObserver.coins) 
		$UpgradeList/Upgrade1/PurchaseButton1.disabled = true
		$UpgradeList/Upgrade1/PurchaseButton1.text = "Purchased"


func _on_purchase_button_2_pressed() -> void:
	if PlayerObserver.coins >= 100:
		PlayerObserver.coins -= 100
		$CoinLabel.text = "Coins: " + str(PlayerObserver.coins) 
		$UpgradeList/Upgrade2/PurchaseButton2.disabled = true
		$UpgradeList/Upgrade2/PurchaseButton2.text = "Purchased"


func _on_purchase_button_3_pressed() -> void:
	if PlayerObserver.coins >= 100:
		PlayerObserver.coins -= 100
		$CoinLabel.text = "Coins: " + str(PlayerObserver.coins) 
		$UpgradeList/Upgrade3/PurchaseButton3.disabled = true
		$UpgradeList/Upgrade3/PurchaseButton3.text = "Purchased"


func _on_purchase_button_4_pressed() -> void:
	if PlayerObserver.coins >= 100:
		PlayerObserver.coins -= 100
		$CoinLabel.text = "Coins: " + str(PlayerObserver.coins) 
		$UpgradeList/Upgrade4/PurchaseButton4.disabled = true
		$UpgradeList/Upgrade4/PurchaseButton4.text = "Purchased"


func _on_purchase_button_5_pressed() -> void:
	if PlayerObserver.coins >= 100:
		PlayerObserver.coins -= 100
		$CoinLabel.text = "Coins: " + str(PlayerObserver.coins) 
		$UpgradeList/Upgrade5/PurchaseButton5.disabled = true
		$UpgradeList/Upgrade5/PurchaseButton5.text = "Purchased"


func _on_purchase_button_6_pressed() -> void:
	if PlayerObserver.coins >= 100:
		PlayerObserver.coins -= 100
		$CoinLabel.text = "Coins: " + str(PlayerObserver.coins) 
		$UpgradeList/Upgrade6/PurchaseButton6.disabled = true
		$UpgradeList/Upgrade6/PurchaseButton6.text = "Purchased"
