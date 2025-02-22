extends Bone2D	

func _process(delta: float) -> void:
	global_position = %arm_right.global_position
	rotation_degrees = %arm_right.rotation_degrees +5
