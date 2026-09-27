extends Node

@export var enemy_scene: PackedScene
@onready var front_enemy_timer: Timer = $FrontEnemyTimer
@onready var front_enemy_spawn_location: PathFollow3D = $FrontSpawnPath/SpawnLocation
@onready var back_enemy_spawn_location: PathFollow3D = $BackSpawnPath/SpawnLocation
@onready var back_enemy_timer: Timer = $BackEnemyTimer
@onready var road: PackedScene = preload('res://scenes/Road.tscn')
@onready var spawn_marker: Marker3D = $SpawnMarker
@onready var added_road: bool = false

const INITIAL_ROADS=20.0
const TILE_SIZE=10.0
const OFFSET= int((INITIAL_ROADS * TILE_SIZE) / 2)

@export var enable_enemies: bool = true

func _ready() -> void:
	if enable_enemies:
		front_enemy_timer.connect('timeout', _on_enemy_timer.bind('front'))
		back_enemy_timer.connect('timeout', _on_enemy_timer.bind('back'))
	_add_initial_road(INITIAL_ROADS)


func _monitor_roads():
	var last_road = roads[roads.size() - 1]
	if last_road.position.z > spawn_marker.position.z && !added_road:
		var new_road: Node3D = road.instantiate()
		added_road = true
		new_road.position.z = last_road.position.z - 9.5
		add_child(new_road)
		roads.append(new_road)


func _physics_process(delta: float) -> void:
	_monitor_roads()



func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_pressed("main_camera"):
		$DebugCamera.current = true
	else:
		$DebugCamera.current = false


var roads: Array[Road] = []
func _add_initial_road(times) -> void:
	for n in times:
		var new_road: Node3D = road.instantiate()
		new_road.position.z = -(n * 10) + OFFSET
		roads.append(new_road)
		add_child(new_road)


func add_road() -> void:
	var new_road: Node3D = road.instantiate()
	new_road.position.x = 0
	new_road.position.z = 0 - OFFSET
	add_child(new_road)


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
