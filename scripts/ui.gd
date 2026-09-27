class_name Ui extends Control

@onready var time_label: Label = $TimeValueContainer/TimeValue
@onready var lives_label: Label = $LivesValueContainer/LivesValue


func update_time(time: String) -> void:
	time_label.text = time
