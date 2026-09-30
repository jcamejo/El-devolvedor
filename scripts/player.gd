class_name Player extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var lives = 3
@onready var enemy_detector = $EnemyDetector
@onready var invincible = false
@onready var animation_player = $AnimationPlayer

signal hit

func _ready():
	enemy_detector.connect('body_entered', report_hit)


func report_hit(_body) -> void:
	if lives == 0:
		return
	lives -= 1
	apply_invincibility()
	hit.emit()


func apply_invincibility() -> void:
	if invincible:
		return

	animation_player.play("invincible")

	enemy_detector.monitoring = false
	invincible = true

	var timer := Timer.new()
	timer.wait_time = 1
	timer.timeout.connect(func():
		invincible = false
		enemy_detector.monitoring = true
	)
	add_child(timer)
	timer.start()


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if lives == 0:
		return

	var input_dir := Input.get_vector("move_left", "move_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
