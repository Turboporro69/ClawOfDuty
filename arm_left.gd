extends Node2D

func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	adjust_rotation()
	rotation_degrees +=180

func adjust_rotation():
	if rotation_degrees > 90 and rotation_degrees < 270:
		#get_tree().root.
		pass
	else:
		pass
