class_name Road
extends Node3D

var speed = 10
const LIMIT=100
@onready var level = $"../"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level.added_road = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position.z += speed * delta

	if position.z >= LIMIT:
		queue_free()
