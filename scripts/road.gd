class_name Road
extends Node3D

var speed = 10
const LIMIT=100

signal out_of_bounds


@onready var level = $"../"
@onready var outer_limit_1 = $OuterLimit1
@onready var outer_limit_2 = $OuterLimit2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level.added_road = false
	outer_limit_1.connect('body_entered', _on_limit_contact)
	outer_limit_2.connect('body_entered', _on_limit_contact)

func _on_limit_contact(body):
	out_of_bounds.emit(body)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position.z += speed * delta

	if position.z >= LIMIT:
		queue_free()
