class_name DialogueLine extends Control

@export var animated_text: String
@export var typing_speed: float = 1
@export var text_order: int = 0

@onready var convo: Label = $Convo

signal finished

func _ready() -> void:
	visible = false

func start() -> void:
	visible = true
	for character in animated_text:
		convo.text += character
		await get_tree().create_timer(typing_speed).timeout


	finished.emit(text_order)
