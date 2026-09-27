class_name Enemy extends CharacterBody3D

@export var min_speed = 100
@export var max_speed = 180

@onready var visibilityNotifier: VisibleOnScreenNotifier3D = $VisibleOnScreenNotifier3D
@onready var random_speed = randi_range(min_speed, max_speed)
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


func _set_color():
	if origin == 'back':
		model.material_override = BACK_ENEMY_MAT
	else:
		model.material_override = FRONT_ENEMY_MAT


func _physics_process(delta: float) -> void:
	velocity.z = random_speed * delta

	if origin == 'back':
		velocity *= -1

	if abs(position.z) > 100:
		queue_free()


	move_and_slide()
