extends Control

@onready var start_line: DialogueLine = $Line1
@onready var finish_line: int = 5
@onready var start_button: Button = $Line5/StartButton


@onready var start_scene: PackedScene = preload('res://scenes/Level.tscn')

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var dialogues = get_tree().get_nodes_in_group('dialogues')
	start_button.connect('button_down', start_game)

	for dialogue in dialogues:
		dialogue.connect('finished', _display_next)

	start_line.start()

func start_game() -> void:
	get_tree().change_scene_to_packed(start_scene)

func _display_next(order):
	if (order + 1) == finish_line:
		$Line5.visible = true
		return

	var next_node: DialogueLine = get_node("Line" + str((order + 1)))
	if next_node:
		next_node.start()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
