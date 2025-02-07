extends Node2D

@onready var bullet_scene = preload("res://Resources/bullet.tscn")
@onready var marker_2d: Marker2D = $Marker2D

func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	rotation()

	if Input.is_action_just_pressed("shoot"):
		shoot()

func shoot():
	var bullet = bullet_scene.instantiate()
	get_tree().root.add_child(bullet)
	bullet.global_position = marker_2d.global_position
	bullet.rotation = rotation
	

func rotation():
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -0.2
	else:
		scale.y = 0.2
