extends Node2D
@onready var mobs = $".."
@onready var animation_player = $AnimationPlayer

var enemy2_prelode = preload("res://Enemy/Enemy 2.tscn")


var spawn_count = 0

func _ready():
	Signals.connect("day_time", Callable(self, "_on_time_changed"))
	
func _on_time_changed(state, day_count):
	spawn_count = 0
	var rng = randi_range(0,2)
	if state == 1:
		for i in (day_count + rng):
			animation_player.play("Spawn")
			await  animation_player.animation_finished
			spawn_count += 1
	if spawn_count == day_count + rng:
		animation_player.play("IDLE")
		

func enemy2_spawn():
	var enemy2 = enemy2_prelode.instantiate()
	enemy2.position = Vector2(self.position.x ,530)
	mobs.add_child(enemy2)
	
