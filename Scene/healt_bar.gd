extends CanvasLayer

@onready var health_bar = $HealtBar
@onready var stamina_bar = $Stamina
@onready var health_Text = $"../HealthText"
@onready var health_anim = $"../HealthAnim"

var stamina_cost
var attack_cost = 10
var block_cost = 5
var stamina = 100
var max_health = Globall.player_health
var old_health = max_health

var health:
	set(value):
		health = clamp(value, 0, max_health)
		health_bar.value = health
		var difference = health - old_health
		health_Text.text = str(difference)
		old_health = health
		if difference < 0:
			health_anim.play("damage_received")
		elif difference > 0:
			health_anim.play("Health_received")
		
		
func _ready():
	health_Text.modulate.a = 0
	health = max_health
	health_bar.max_value = health
	health_bar.value = health

func _process(delta):
	stamina_bar.value = stamina
	if stamina < 100:
		stamina += 10 * delta
		
		
func stamina_consumption():
	stamina -= stamina_cost


func _on_health_regen_timeout():
		health += 1
