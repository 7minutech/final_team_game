extends Node2D

const image1 = preload("res://icon.svg")
const image2 = preload("res://assets/hud/ability_symbols/filled_pip/AbilityPip_Filled.png")
const image3 = preload("res://assets/hud/ability_symbols/empty_pip/AbilityPip_Empty.png")
const message: String = "Pretyped Text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	addAbility(image2, str(2))
	addAbility(image3, str(3))

# Called every frame. 'delta' is the elapsed time since the previous frame.f
func _process(delta: float) -> void:
	pass

# Function to add ability images to the label
func addAbility(image, tooltip: String) -> void:
	for i in range(4):
		$Ability.add_image(image, 50, 50, Color(1,1,1), INLINE_ALIGNMENT_CENTER, Rect2(0,0,0, 0), null, false, tooltip, false)
		$AbilityBG.add_image(image1, 50, 50, Color(1,1,1), INLINE_ALIGNMENT_CENTER)
	
	
