extends Node

@export var enemy_scene: PackedScene
@onready var enemy_timer: Timer = $EnemyTimer
@onready var enemy_spawn_location: PathFollow3D = $SpawnPath/SpawnLocation
@onready var rear_view_right = $CameraPivot/RearViewRight
@onready var rear_view_left = $CameraPivot/RearViewLeft
@onready var main_camera = $CameraPivot/Camera3D

func _ready() -> void:
	enemy_timer.connect('timeout', _on_enemy_timer_timeout)
	
func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_rear_view"):
		rear_view_left.current = true
	if Input.is_action_just_pressed("right_rear_view"):
		rear_view_right.current = true
	
	if Input.is_action_just_pressed('main_camera'):
		main_camera.current = true
			
			


func _on_enemy_timer_timeout() -> void:
	var enemy = enemy_scene.instantiate()
	
	enemy_spawn_location.progress_ratio = randf()
	enemy.initialize(enemy_spawn_location.position)
	
	add_child(enemy)
	
	
