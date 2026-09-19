extends CharacterBody3D

@export var min_speed = 10
@export var max_speed = 18

@onready var visibilityNotifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier3D


func _ready() -> void:
	visibilityNotifier.connect('screen_exited', _on_screen_exited)

func _on_screen_exited():
	queue_free()

func initialize(_start_position, _end_position):
	var _random_speed = randi_range(min_speed, max_speed)
	

func _physics_process(_delta: float) -> void:
	move_and_slide()
