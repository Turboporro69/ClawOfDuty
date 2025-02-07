extends Node2D

@onready var bullet_scene = preload("res://Resources/bullet.tscn")
@onready var marker_2d: Marker2D = $Marker2D
@onready var player = preload("res://player.tscn")
var player_instance
var last_shoot_time

func _ready():
	pass

func _process(delta: float) -> void:
	if player != null:
		look_at(player.global_position)
		rotation_degrees = wrap(rotation_degrees, 0, 360)
		rotation()

func rotation():
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -0.2
	else:
		scale.y = 0.2
	
func shoot():
	var bullet = bullet_scene.instantiate()
	get_tree().root.add_child(bullet)
	bullet.global_position = marker_2d.global_position
	bullet.rotation = rotation
	
	last_shoot_time = 0
	
