extends Node2D

enum {
	MORNING,
	DAY,
	EVENING,
	NIGHT
}

@onready var light = $DirectionalLight2D
@onready var day_txt = $CanvasLayer/DayText
@onready var animPlayer = $CanvasLayer/AnimationPlayer
@onready var player = $Player/Character

var state = MORNING
var day_count: int

func _ready():
	Globall.gold = 0
	if light.enabled == false:
		light.enabled = true
	day_count = 1
	set_day_text()
	day_text_fade()
func morning_state():
	var tween = get_tree().create_tween()
	tween.tween_property(light, "energy", 0.2, 15)

func evening_state():
	var tween = get_tree().create_tween()
	tween.tween_property(light, "energy", 0.93, 20)
	
func set_day_text():
	day_txt.text = "DAY " + str(day_count)
	
func _on_day_night_timeout():
	print("Timeout!")
	match state:
		MORNING:
			morning_state()
			state = DAY
		DAY:
			evening_state()
			state = EVENING
		EVENING:
			state = NIGHT
		NIGHT:
			state = MORNING
			day_count += 1
			set_day_text()
			day_text_fade()
	Signals.emit_signal("day_time", state, day_count)
			
func day_text_fade ():
	animPlayer.play("day_fade_in")
	await get_tree().create_timer(3).timeout
	animPlayer.play("day_fade_out")

