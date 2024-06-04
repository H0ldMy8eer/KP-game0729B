extends CharacterBody2D



enum {
	ATTACK,
	ATTACK2,
	ATTACKH,
	MOVE,
	DAMAGE,
	DEATH,
	BLOCK,
	JUMP
}


const SPEED = 170.0
const JUMP_VELOCITY = -550.0
var damage_bassic = 10
var damage_multiplier = 1
var damage_current
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player_pos

var combo = false
@onready var anim = $AnimatedSprite2D
@onready var animPlayer = $AnimationPlayer
@onready var stats = $Stats
@onready var leafs = $leafs

var state = MOVE
var run_speed = 2

func _ready():
	
	Signals.connect("enemy_attack", Callable (self, "_on_damage_received"))
	
	
	
func _physics_process(delta):
	damage_current = damage_bassic * damage_multiplier
	player_pos = self.position
	Signals.emit_signal("player_position_update", player_pos)
	match state:
		MOVE:
			move_state()
		ATTACK:
			attack_state()
		ATTACK2:
			attack2_state()
		ATTACKH:
			attackH_state()
		DEATH:
			death_state()
		JUMP:
			jump_state()
		DAMAGE:
			damage_state()
		BLOCK:
			block_state()
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		animPlayer.play("Falling")


	move_and_slide()

var is_falling = false

func move_state():
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED * run_speed
		if velocity.y == 0 and not is_falling:
			animPlayer.play("Run")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0 and is_falling:
			animPlayer.play("Idle")
			is_falling = false
		if direction == -1:
			anim.flip_h = true
			$AttackDirection.rotation_degrees = 180
		elif direction == 1:
			anim.flip_h = false
			$AttackDirection.rotation_degrees = 0
			
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			animPlayer.play("Idle")
	if Input.is_action_just_pressed("Jump"):
		if is_on_floor():
			state = JUMP
	if Input.is_action_just_pressed("block"):
		state = BLOCK
	if Input.is_action_just_pressed("attack"):
		stats.stamina_cost = stats.attack_cost
		if stats.stamina_cost < stats.stamina:
			state = ATTACK

func fall_state():
	is_falling = true
	animPlayer.play("Falling")
func jump_state():
	animPlayer.play("Jump")
	velocity.y = JUMP_VELOCITY
	if is_on_floor():
		state = MOVE
func block_state():
	velocity.x = 0
	animPlayer.play("Block")
	if Input.is_action_just_released("block"):
		state = MOVE
func death_state():
	velocity.x = 0
	animPlayer.play("Death")
	await get_tree().create_timer(0.55).timeout  
	get_tree().change_scene_to_file("res://death_screen.tscn")
	queue_free()

func attack_state():
	stats.stamina_cost = stats.attack_cost
	damage_multiplier = 1
	if Input.is_action_just_pressed("attack") and combo == true and stats.stamina_cost < stats.stamina:
		state = ATTACK2
	velocity.x = 0
	animPlayer.play("Attack1")
	await animPlayer.animation_finished
	state = MOVE
func attack2_state():
	stats.stamina_cost = stats.attack_cost
	if Input.is_action_just_pressed("block") and combo == true and stats.stamina_cost < stats.stamina:
		state = ATTACKH
	animPlayer.play("Attack2")
	damage_multiplier = 1.5
	await animPlayer.animation_finished
	state = MOVE
func attackH_state():
	stats.stamina_cost = stats.attack_cost + 25
	damage_multiplier = 4
	animPlayer.play("AttackH")
	await animPlayer.animation_finished
	state = MOVE
func combo1():
	
	combo = true
	await animPlayer.animation_finished
	combo = false
func damage_state():
	velocity.x = 0
	animPlayer.play("Damage")
	await animPlayer.animation_finished
	state = MOVE
func _on_damage_received (enemy_damage):
	if state == BLOCK:
		stats.health -=  (enemy_damage / 2)
	else:
		stats.health -= enemy_damage
	if stats.health <= 0:
		stats.health = 0
		state = DEATH
	else:
		state = DAMAGE


func _on_hitbox_area_entered(_area):
	Signals.emit_signal("player_attack", damage_current)

func steps():
	leafs.emitting = true
	leafs.one_shot = true
