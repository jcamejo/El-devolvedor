extends Node

@export var enemy_scene: PackedScene
@onready var enemy_timer: Timer = $EnemyTimer
@onready var enemy_spawn_location: PathFollow3D = $SpawnPath/SpawnLocation

func _ready() -> void:
	enemy_timer.connect('timeout', _on_enemy_timer_timeout)
	
	

func _on_enemy_timer_timeout() -> void:
	var enemy = enemy_scene.instantiate()
	
	enemy_spawn_location.progress_ratio = randf()
	
	enemy.global_position = enemy_spawn_location.position
	
	add_child(enemy)
	
	
