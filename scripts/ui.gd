class_name Ui extends Control

@onready var time_label: Label = $TimeValueContainer/TimeValue
@onready var lives_label: Label = $LivesValueContainer/LivesValue
@onready var win_panel: Panel = $WinPanel
@onready var lose_panel: Panel = $LosePanel
@onready var restart_win: Button = $WinPanel/RestartWin
@onready var restart_lose: Button = $LosePanel/RestartLose

signal restart

func _ready() -> void:
	win_panel.visible = false
	lose_panel.visible = false

	restart_win.connect('button_up', request_restart)
	restart_lose.connect('button_up', request_restart)

func request_restart() -> void:
	restart.emit()

func update_time(time: String) -> void:
	time_label.text = time

func update_lives(lives: String) -> void:
	lives_label.text = lives


func show_win_state() -> void:
	win_panel.visible = true

func show_lose_state() -> void:
	lose_panel.visible = true
