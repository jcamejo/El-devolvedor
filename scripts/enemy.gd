class_name Enemy extends CharacterBody3D

@export var min_speed = 100
@export var max_speed = 180

@export var front_min_speed = 200
@export var front_max_speed = 250

@export var back_min_speed = 140
@export var back_max_speed = 180

@onready var visibilityNotifier: VisibleOnScreenNotifier3D = $VisibleOnScreenNotifier3D
@onready var random_speed = randi_range(min_speed, max_speed)
@onready var speed: int
@onready var origin: String
@onready var model: MeshInstance3D = $Pivot/Model

const FRONT_ENEMY_MAT = preload('res://resources/front_enemy.tres')
const BACK_ENEMY_MAT = preload('res://resources/back_enemy.tres')

func _ready() -> void:
	visibilityNotifier.connect('screen_exited', _on_screen_exited)
	_set_color()


func _on_screen_exited():
	queue_free()


func initialize(start_position, origins):
	position = start_position
	origin = origins

	if origin == 'back':
		speed = randi_range(back_min_speed, back_max_speed)
		rotate_y(deg_to_rad(180))
	else:
		rotate_y(-deg_to_rad(180))
		speed = randi_range(front_min_speed, front_max_speed)


func _set_color():
	if origin == 'back':
		model.material_override = BACK_ENEMY_MAT
	else:
		model.material_override = FRONT_ENEMY_MAT


func _physics_process(delta: float) -> void:
	velocity.z = speed * delta

	if origin == 'back':
		velocity *= -1

	if abs(position.z) > 100:
		queue_free()

	move_and_slide()
