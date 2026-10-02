class_name Player extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var lives = 3
@onready var enemy_detector = $EnemyDetector
@onready var invincible = false
@onready var animation_player = $AnimationPlayer
@onready var camera_front_rear_r = $CameraFrontRearR
@onready var camera_front_rear_l = $CameraFrontRearL
@onready var main_camera = $MainCamera

const INVINCIBLE_TIME = 2

signal hit

func _ready():
	enemy_detector.connect('body_entered', report_hit)


func _process(_delta) -> void:
	if Input.is_action_pressed("close_right_rear"):
		camera_front_rear_r.make_current()
	elif Input.is_action_pressed("close_left_rear"):
		camera_front_rear_l.make_current()
	else:
		main_camera.make_current()


func report_hit(_body) -> void:
	if lives == 0:
		return
	process_hit()
	hit.emit()


func process_hit() -> void:
	if invincible:
		return

	invincible = true
	lives -= 1
	animation_player.play("invincible")

	enemy_detector.set_deferred("monitoring", false)

	var timer := Timer.new()
	timer.wait_time = INVINCIBLE_TIME
	timer.timeout.connect(func():
		invincible = false
		enemy_detector.set_deferred("monitoring", true)
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
