extends Node2D

@onready var bullet_scene = preload("res://Resources/bullet.tscn")

func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	rotation()

	if Input.is_action_just_pressed("shoot"):
		shoot()

func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.position = position
	bullet.bullet_direction = (position - get_global_mouse_position()).normalized()
	bullet.look_at(get_global_mouse_position())
	get_parent().add_child(bullet)
	

func rotation():
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -0.2
	else:
		scale.y = 0.2
