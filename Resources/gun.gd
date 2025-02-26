extends Node2D
@onready var pewpew = $pewpew
@onready var bullet_scene = preload("res://Resources/bullet.tscn")
@onready var marker_2d: Marker2D = $Marker2D
@export var scale_gun: float 
var pewpewcooldown = true
var moving = false
var drift = 0
signal left
signal right
var primary_weapon : Resource = preload("res://Weapons/test.tres")
var primary_data = {
	"Texture": primary_weapon.Texture,
	"Name": primary_weapon.Name
}
var secondary_weapon

func _process(delta: float) -> void:
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	rotation()


	var jambo = get_parent()
	if jambo == null or jambo is not CharacterBody2D:
		pass
	else:
		if jambo.velocity.length() > 0:
			moving = true
		else:
			moving = false


	if Input.is_action_pressed("shoot") and pewpewcooldown == true :
		shoot()
	
	PrimaryWeapon()

func shoot():
	if moving == true:
		drift = deg_to_rad(randf_range(-15, 15))
	else:
		drift = deg_to_rad(randf_range(-5, 5))
	pewpewcooldown = false
	pewpew.start()
	var bullet = bullet_scene.instantiate()
	get_tree().root.add_child(bullet)
	bullet.global_position = marker_2d.global_position
	bullet.rotation = rotation + drift
	

func rotation():
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -scale_gun
		emit_signal("left")
	else:
		scale.y = scale_gun
		emit_signal("right")

func _on_pewpew_timeout() -> void:
	pewpewcooldown = true

func PrimaryWeapon():
	if Input.is_action_just_pressed("PrimaryWeapon"):
		pass
		
