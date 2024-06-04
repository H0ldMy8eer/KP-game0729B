extends CharacterBody2D

class_name Enemy

enum {
	IDLE,
	ATTACK,
	CHASE,
	DAMAGE,
	RECOVER,
	DEATH
}
var state: int = 0:
	set(value):
		state = value
		match state:
			IDLE:
				idle_state()
			ATTACK:
				attack_state()
			DAMAGE:
				damage_state()
			RECOVER:
				recover_state()
			DEATH:
				death_state()

@onready var animPlayer = $AnimationPlayer
@onready var sprite = $AnimatedSprite2D
var player = Vector2.ZERO
var direction = Vector2.ZERO
var move_speed = 125
var damage = 20

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
func _ready():
	Signals.connect("player_position_update", Callable(self, "_on_player_position_update"))
	state = CHASE

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if state == CHASE:
		chase_state()
	
	move_and_slide()
func _on_player_position_update(player_pos):
	player = player_pos
	
func chase_state():
	animPlayer.play("Run")
	direction = (player - self.position).normalized()
	if direction.x < 0:
		sprite.flip_h = true
		$Node2D/AttackRange.rotation_degrees = 180
		$Node2D/DamageBox/Hitbox.rotation_degrees = 180
	else:
		sprite.flip_h = false
		$Node2D/AttackRange.rotation_degrees = 0
		$Node2D/DamageBox/Hitbox.rotation_degrees = 0
	velocity.x = direction.x * move_speed

func _on_attack_range_body_entered(_body):
	state = ATTACK

func idle_state():
	velocity.x = 0
	animPlayer.play("Idle")
	await get_tree().create_timer(1).timeout
	state = CHASE

func attack_state():
	velocity.x = 0
	animPlayer.play("Attack")
	await animPlayer.animation_finished
	state = IDLE

func damage_state():
	velocity.x = 0
	animPlayer.play("Damage")
	await animPlayer.animation_finished
	state = IDLE

func death_state():
	velocity.x = 0

	animPlayer.play("Damage")
	await animPlayer.animation_finished
	queue_free()

func recover_state():
	velocity.x = 0
	animPlayer.play("Recover")
	await animPlayer.animation_finished
	state = IDLE



func _on_hitbox_area_entered(_area):
	Signals.emit_signal("enemy_attack", damage)





func _on_run_timeout():
	move_speed = move_toward(move_speed, randi_range(100,170), 100)
