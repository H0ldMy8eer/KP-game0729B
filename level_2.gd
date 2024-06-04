extends Node2D
@onready var light = $Light/DirectionalLight2D
enum{
	MORNING,
	DAY,
	EVENING,
	NIGHT
}
var state = NIGHT
func _ready():
	if light.enabled == false:
		light.enabled = true





func _process(delta):
	pass

func morning_state():
	var tween = get_tree().create_tween()
	tween.tween_property(light, "energy", 0.2, 20)

func evening_state():
	var tween = get_tree().create_tween()
	tween.tween_property(light, "energy", 0.93, 20)

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

