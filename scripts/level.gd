extends Node

@export var enemy_scene: PackedScene
@onready var front_enemy_timer: Timer = $FrontEnemyTimer
@onready var front_enemy_spawn_location: PathFollow3D = $FrontSpawnPath/SpawnLocation
@onready var back_enemy_spawn_location: PathFollow3D = $BackSpawnPath/SpawnLocation
@onready var back_enemy_timer: Timer = $BackEnemyTimer


func _ready() -> void:
	front_enemy_timer.connect('timeout', _on_enemy_timer.bind('front'))
	back_enemy_timer.connect('timeout', _on_enemy_timer.bind('back'))
func _unhandled_input(_event: InputEvent) -> void:
	pass


func _on_enemy_timer(orientation: String) -> void:
	var enemy: Enemy = enemy_scene.instantiate()
	var location: PathFollow3D

	if orientation == 'front':
		location = front_enemy_spawn_location
	else:
		location = back_enemy_spawn_location

	location.progress_ratio = randf()
	enemy.initialize(location.position, orientation)

	add_child(enemy)
