extends CharacterBody3D

@export var min_speed = 100
@export var max_speed = 180

@onready var visibilityNotifier: VisibleOnScreenNotifier3D = $VisibleOnScreenNotifier3D
@onready var random_speed = randi_range(min_speed, max_speed)

func _ready() -> void:
	visibilityNotifier.connect('screen_exited', _on_screen_exited)


func _on_screen_exited():
	queue_free()


func initialize(start_position):
	position = start_position
	

func _physics_process(delta: float) -> void:
	velocity.z = random_speed * delta
	move_and_slide()
