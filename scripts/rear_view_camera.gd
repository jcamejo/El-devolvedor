extends Camera3D

@export var mount: Node3D

func _process(_delta: float) -> void:
	if not is_inside_tree():
		return
	if mount:
		global_transform = mount.global_transform
