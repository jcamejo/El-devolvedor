extends Node

@export var enemy_scene: PackedScene
@onready var enemy_timer: Timer = $EnemyTimer
@onready var enemy_spawn_location: PathFollow3D = $SpawnPath/SpawnLocation

func _ready() -> void:
	enemy_timer.connect('timeout', _on_enemy_timer_timeout)

func _unhandled_input(_event: InputEvent) -> void:
	pass


func _on_enemy_timer_timeout() -> void:
	var enemy = enemy_scene.instantiate()

	enemy_spawn_location.progress_ratio = randf()
	enemy.initialize(enemy_spawn_location.position)

	add_child(enemy)
