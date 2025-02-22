extends Bone2D
@onready var marker2d : Marker2D = $hand_right/Marker2D
@onready var gun : Node2D = %Gun
@onready var root : Node2D = get_parent() 
@export var scale_player : float

func _process(delta: float) -> void:
	pass
	#look_at(get_global_mouse_position())
	#rotation_degrees = wrap(rotation_degrees, 0, 360)
	#adjust_rotation_arm()
	#rotation_degrees += 180
	#update_gun_position()
#
#func adjust_rotation_arm():
	#if rotation_degrees > 178 and rotation_degrees < 528:
		#pass
	#else:
		#pass
#
#func update_gun_position():
	#gun.global_position = marker2d.global_position
	#gun.rotation_degrees = marker2d.global_rotation_degrees
#
#func change_root_scale_y(new_scale_y: float) -> void:
	#root.scale.y = new_scale_y
