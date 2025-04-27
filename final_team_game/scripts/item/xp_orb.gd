extends Area2D

class_name XPOrb2

const INITIAL_XP_VALUE: int = 10

var xp_value: int = INITIAL_XP_VALUE
var chance_of_red: float = 0.05
var chance_of_green: float = 0.2
var color: String
var orginal_color: Color = Color("ffffff")
var green_color: Color = Color("96ed4e")
var blue_green_color: Color = Color("85ff89")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scale_xp()
	set_color_xp_values()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func set_xp_value(value: int) -> void:
	self.xp_value = value



func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is Player:
		set_pitch_scale()
		$PickUpSound.play()
		var player: Player = parent
		var tween = create_tween()
		tween.tween_property(self, "global_position", player.global_position, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.connect("finished", Callable(self, "_on_tween_finished").bind(player))

func _on_tween_finished(player: Player) -> void:
	player.give_xp(self)
	queue_free()

func set_pitch_scale() -> void:
	var pitch := randf_range(0.9,1.1)
	$PickUpSound.pitch_scale = pitch

func set_color_field() -> void:
	var rnum = randf()
	if rnum <= chance_of_red:
		color = "blue_green"
	elif rnum <= chance_of_green:
		color = "green"
	else:
		color = "blue"
	pass

func set_color_sprite() -> void:
	if color == "blue_green":
		$Sprite2D.modulate = blue_green_color
	elif color == "green":
		$Sprite2D.modulate = green_color
	else:
		$Sprite2D.modulate = orginal_color
	pass
func set_color_xp_value() -> void:
	if color == "blue_green":
		set_xp_value(xp_value * 20)
	elif color == "green":
		set_xp_value(xp_value * 10)
	else:
		set_xp_value(xp_value)
	
	pass

func set_color_xp_values() -> void:
	set_color_field()
	set_color_sprite()
	set_color_xp_value()

func scale_xp() -> void:
	#xp value += minute * 5
	#first minute is 1 then second is 5 thrid is 10
	var adder: int = (TimeObserver.total_time / 60) * 5
	if adder <= 0:
		adder = 1
	#after first minute xp gets 15
	set_xp_value(INITIAL_XP_VALUE + adder)
	pass
