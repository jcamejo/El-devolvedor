extends Node

@export var initial_time: int = 0
@export var enemy_scene: PackedScene
@export var enemy_ghost_scene: PackedScene
@onready var front_enemy_timer: Timer = $FrontEnemyTimer
@onready var front_enemy_spawn_location: PathFollow3D = $FrontSpawnPath/SpawnLocation
@onready var back_enemy_spawn_location: PathFollow3D = $BackSpawnPath/SpawnLocation
@onready var back_enemy_timer: Timer = $BackEnemyTimer
@onready var road: PackedScene = preload('res://scenes/Road.tscn')
@onready var spawn_marker: Marker3D = $SpawnMarker
@onready var added_road: bool = false
@onready var front_detector: Area3D = $FrontDetector
@onready var back_detector: Area3D = $BackDetector
@onready var front_disposal: Area3D = $FrontDisposalDetector
@onready var back_disposal: Area3D = $BackDisposalDetector
@onready var ui: Ui = $CanvasLayer/UI
@onready var current_time: int = initial_time

const INITIAL_ROADS=20.0
const TILE_SIZE=10.0
const OFFSET= int((INITIAL_ROADS * TILE_SIZE) / 2)

var roads: Array[Road] = []

@export var enable_enemies: bool = true

func _ready() -> void:
	if enable_enemies:
		#front_enemy_timer.connect('timeout', _on_enemy_timer.bind('front'))
		front_enemy_timer.connect('timeout', _on_enemy_ghost_timer.bind('front'))
		back_enemy_timer.connect('timeout', _on_enemy_ghost_timer.bind('back'))
	_add_initial_road(INITIAL_ROADS)

	front_detector.connect('area_entered', _on_front_ghost_entered)
	back_detector.connect('area_entered', _on_back_ghost_entered)

	front_disposal.connect('body_entered', _dispose)
	back_disposal.connect('body_entered', _dispose)
#
	front_disposal.connect('area_entered', _dispose)
	back_disposal.connect('area_entered', _dispose)

	_start_timer()

func _start_timer() -> void:
	ui.update_time(str(initial_time))

	var timer := Timer.new()
	timer.one_shot = false
	timer.autostart = true
	timer.wait_time = 1
	timer.connect('timeout', func():
		current_time += 1
		print('timeout')
		ui.update_time(str(current_time))
	)
	add_child(timer)


func _dispose(body) -> void:
	body.queue_free()

func _on_front_ghost_entered(area: Area3D) -> void:
	var initial_position = front_enemy_spawn_location.position
	initial_position.x = area.position.x
	_spawn_enemy(initial_position, 'front')


func _on_back_ghost_entered(area) -> void:
	var initial_position = back_enemy_spawn_location.position
	initial_position.x = area.position.x
	_spawn_enemy(initial_position, 'back')


func _monitor_roads():
	var last_road = roads[roads.size() - 1]
	if last_road.position.z > spawn_marker.position.z && !added_road:
		var new_road: Node3D = road.instantiate()
		added_road = true
		new_road.position.z = last_road.position.z - 9.5 # 9.5 is the size of the road
		add_child(new_road)
		roads.append(new_road)


func _physics_process(_delta: float) -> void:
	_monitor_roads()


func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_pressed("main_camera"):
		$DebugCamera.current = true
	else:
		$DebugCamera.current = false


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

func _spawn_enemy(position, orientation) -> void:
	var enemy: Enemy = enemy_scene.instantiate()
	enemy.initialize(position, orientation)
	add_child(enemy)


func _on_enemy_ghost_timer(orientation: String) -> void:
	var enemy_ghost: EnemyGhost = enemy_ghost_scene.instantiate()
	var location: PathFollow3D

	if orientation == 'front':
		location = front_enemy_spawn_location
	else:
		location = back_enemy_spawn_location

	location.progress_ratio = randf()
	enemy_ghost.initialize(location.position, orientation)

	add_child(enemy_ghost)
