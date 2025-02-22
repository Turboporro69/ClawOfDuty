extends CharacterBody2D
class_name Player2

@onready var dashduration = $dashduration
@onready var dashcooldown = $dashcooldown
@export var normal_speed = 300.0
@export var dash_speed = 600.0
var speed = normal_speed
var is_dashing = false
var dash_available = true
@export var health : int
signal player_death
var player_dead = false
@export var scale_player : float
@onready var arm_left = $Skeleton2D/hip/chest/arm_left
@onready var arm_right = $Skeleton2D/hip/chest/arm_right
@onready var marker2d_arm : Marker2D = $Skeleton2D/hip/chest/arm_right/hand_right/Marker2D
@onready var skeleton : Skeleton2D = $Skeleton2D
@onready var gun_handle_marker2d : Marker2D = $Gun/GunHandle
@onready var gun : Node2D = $Gun
var flip_h : bool = false
@onready var polygons : Node2D = $polygons

func _ready():
	$polygons.visible = true
	$Gun/Sprite2D.visible = true
	$CollisionShape2D.disabled = false

func _physics_process(delta: float) -> void:
	if health == 0 and not player_dead:
		player_dead = true
		$polygons.visible = false
		$Gun/Sprite2D.visible = false
		$CollisionShape2D.disabled = true
		health_label()
		score.enemy_score += 1
		emit_signal("player_death")
	else:
		var direction_x := Input.get_axis("ui_left", "ui_right")
		if direction_x:
			velocity.x = direction_x * speed

		else:
			velocity.x = move_toward(velocity.x, 0, speed)
		var direction_y := Input.get_axis("ui_up", "ui_down")
		if direction_y:
			velocity.y = direction_y * speed
		else:
			velocity.y = move_toward(velocity.y, 0, speed)
			
		move_and_slide()
		
		if Input.is_action_just_pressed("wedashing") and dash_available == true and not is_dashing:
			start_wedashing()
			
		health_label()
		arm_rotation()
		#if flip_h == true:
			#gun.rotation_degrees = gun.rotation_degrees * -1
			#gun.scale.y = gun.scale.y * -1
			#gun.scale.x = gun.scale_gun * -1
			#
		#elif flip_h == false:
			#gun.rotation_degrees = gun.rotation_degrees
			#gun.scale.y = gun.scale.y 
			#gun.scale.x = gun.scale_gun
		_on_gun_left()
		_on_gun_right()

func start_wedashing():
	is_dashing = true
	dash_available = false
	speed = dash_speed
	dashcooldown.start()
	dashduration.start()
	
func _on_dashduration_timeout() -> void:
	is_dashing = false
	speed = normal_speed

func _on_dashcooldown_timeout() -> void:
	dash_available = true

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullets"):
		health -= 1

func health_label():
	#$Camera2D/Label.text = "<3: " + str(health) + "/3"
	pass
func left_arm_rotation():
	arm_left.global_position = arm_right.global_position
	arm_left.rotation_degrees = arm_right.rotation_degrees + 5

func update_gun_position():
	gun.global_position = marker2d_arm.global_position
	gun.rotation_degrees = marker2d_arm.global_rotation_degrees

func arm_rotation():
	arm_right.look_at(get_global_mouse_position())
	arm_right.rotation_degrees = wrap(arm_right.rotation_degrees, 0, 360)
	arm_right.rotation_degrees += 180
	left_arm_rotation()
	update_gun_position()

func _on_gun_left() -> void:
	polygons.scale.x = -1
	#rotation_degrees = 180
	flip_h = true
#
func _on_gun_right() -> void:
	polygons.scale.x = 1
	#rotation_degrees = 0
	flip_h = false
