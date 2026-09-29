class_name EnemyGhost extends Area3D

const speed = 100
const OFFSET = 1
var origin: String

func initialize(start_position, orientation) -> void:
	position = start_position
	origin = orientation
	position.y += OFFSET

func _ready() -> void:
	connect('body_entered', _on_enemy_detection)

func _on_enemy_detection(_body) -> void:
	queue_free()


func _physics_process(delta: float) -> void:
	var movement = speed * delta

	if origin == 'back':
		movement *= -1

	position.z += movement
