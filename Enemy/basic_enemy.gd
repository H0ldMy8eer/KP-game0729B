extends CharacterBody2D
enum {
	IDLE,
	ATTACK,
	CHASE,
	DAMAGE,
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
			DEATH:
				death_state()

@onready var animPlayer = $AnimationPlayer
@onready var sprite = $AnimatedSprite2D
var player
var direction

var damage = 20
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
func _ready():
	Signals.connect("player_position_update", Callable(self, "_on_player_position_update"))


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if state == CHASE:
		chase_state()
	
	move_and_slide()
func _on_player_position_update(player_pos):
	player = player_pos
	
func chase_state():
	direction = (player - self.position).normalized()
	if direction.x < 0:
		sprite.flip_h = true
		$Node2D/AttackRange.rotation_degrees = 180
		$Node2D/DamageBox/Hitbox.rotation_degrees = 180
	else:
		sprite.flip_h = false
		$Node2D/AttackRange.rotation_degrees = 0
		$Node2D/DamageBox/Hitbox.rotation_degrees = 0

func _on_attack_range_body_entered(body):
	state = ATTACK

func idle_state():
	animPlayer.play("Idle")
	await get_tree().create_timer(1).timeout
	state = CHASE

func attack_state():
	animPlayer.play("Attack")
	await animPlayer.animation_finished
	state = IDLE

func damage_state():
	animPlayer.play("Damage")
	await animPlayer.animation_finished
	state = IDLE

func death_state():
	animPlayer.play("Damage")
	await animPlayer.animation_finished
	queue_free()



func _on_hitbox_area_entered(area):
	Signals.emit_signal("enemy_attack", damage)


func _on_mob_health_damage_received():
	state = IDLE
	state = DAMAGE
	

func _on_mob_health_no_health():
	state = DEATH
