extends Node2D

@onready var bullet_scene = preload("res://Resources/bullet.tscn")
@onready var marker_2d: Marker2D = $Marker2D
@onready var player_instance = preload("res://player.tscn")
var player
var last_shoot_time = 0
var shoot_cooldown = .5

func _ready():
	player = get_parent().get_node("../player")

func _process(delta: float) -> void:
	if player:
		var direction = (player.global_position - global_position).normalized()
		rotation = direction.angle()
		update_rotation()
		
	last_shoot_time += delta

func update_rotation():
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -0.2
	else:
		scale.y = 0.2

func _on_enemy_player_seen() -> void:
	if last_shoot_time >= shoot_cooldown:
		var bullet = bullet_scene.instantiate()
		get_tree().root.add_child(bullet)
		bullet.global_position = marker_2d.global_position
		bullet.rotation = rotation
		
		last_shoot_time = 0
