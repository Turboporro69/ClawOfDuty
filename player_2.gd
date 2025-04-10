extends CharacterBody2D
class_name Player
@onready var dashduration = $dashduration
@onready var dashcooldown = $dashcooldown
@export var normal_speed = 300.0
@export var dash_speed = 600.0
var speed = normal_speed
@onready var round_reset_timer: Timer = Timer.new()
var is_dashing = false
var max_health = 100
var dash_available = true
@export var health : int
signal player_death
var player_dead = false
@export var scale_player : float
@onready var arm_left = $Player/Skeleton/Skeleton2D/hip/chest/arm_left
@onready var arm_right = $Player/Skeleton/Skeleton2D/hip/chest/arm_right
@onready var marker2d_arm : Marker2D = $Player/Skeleton/Skeleton2D/hip/chest/arm_right/Marker2D
@onready var skeleton : Skeleton2D = $Player/Skeleton/Skeleton2D
@onready var gun_handle_marker2d : Marker2D = $Gun/GunHandle
@onready var blinking_timer : Timer = $Player/polygons/head/blinking
@onready var gun : Node2D = $Gun
var flip_h : bool = false
@onready var polygons : Node2D = $Player/polygons
@onready var gun_damage = $Gun.damage
var mouse_position
@onready var leg_left = $Player/Skeleton/Skeleton2D/hip/leg_left
@onready var leg_right = $Player/Skeleton/Skeleton2D/hip/leg_right
@onready var walk_particle = $Player/GPUParticles2D
var walk_cycle_time = 0.0
var walk_speed = 10.0 
var selected_character
var player_id: int = -1
@export var primary_weapons: Array[Weapons] = []
@export var secondary_weapons: Array[Weapons] = []

func _ready():
	if is_in_group("fox"):
		global_position = Global2Vs2.fox_spawn_point
	else:
		global_position = Global2Vs2.tiger_spawn_point
	$Gun/Sprite2D.visible = true
	$CollisionShape2D.disabled = false
	$PointLight2D.visible = false
	$CanvasLayer.visible = false

	if is_multiplayer_authority():
		add_child(round_reset_timer)
		var camera = Camera2D.new()
		add_child(camera)
		camera.make_current()
		camera.zoom.x = 0.8
		camera.zoom.y = 0.8
		
		$PointLight2D.visible = false
		$CanvasLayer.visible = false
		
	set_physics_process(is_multiplayer_authority())
	blinking()
	walk_particle.emitting = false

func _physics_process(delta: float) -> void: 
	health_label()
	$CanvasLayer/Control/fox/Label.text = str(Global2Vs2.fox_score)
	$CanvasLayer/Control/tiger/Label.text = str(Global2Vs2.tiger_score)
	
	walk_particle.emitting = false
	arm_rotation()
	if velocity.length() > 0 and player_dead != true:
		walk_particle.emitting = true
		animate_legs(delta)
	else:
		walk_particle.emitting = false
		reset_leg_positions()
	$Mouse.global_position = get_global_mouse_position()
	$Gun.feet_position = $feet.global_position
	
	if health == 0 and player_dead == false:
		player_dead = true
		polygons.visible = false
		$Gun.visible = false
		$CollisionShape2D.disabled = true
		$CanvasLayer/Shop.visible = false
		$CanvasLayer/health.visible = false
		if is_in_group("fox"):
			Global2Vs2.fox_death = 1
		else:
			Global2Vs2.tiger_death = 1
		reset_round.rpc()
		
		health_label()
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
			update_rotation()

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
		health -= area.damage
		health = max(health, 0)
		health_label()

func left_arm_rotation():
	arm_left.look_at(get_global_mouse_position())
	#arm_left.rotation_degrees = arm_right.rotation_degrees
	arm_left.rotation_degrees = wrap(arm_right.rotation_degrees, 0, 360)
	
func update_gun_position():
	$Gun.global_position = marker2d_arm.global_position
	$Gun.rotation_degrees = marker2d_arm.global_rotation_degrees

func arm_rotation():
	arm_right.look_at(get_global_mouse_position())
	arm_right.rotation_degrees = wrap(arm_right.rotation_degrees, 0, 360)
	#arm_right.rotation_degrees += 180
	left_arm_rotation()
	update_gun_position()

func _on_gun_left() -> void:
	$Player.scale.x = -1.2
	$Gun.scale.y = -$Gun.scale_gun
	#rotation_degrees = 180
	flip_h = true

func _on_gun_right() -> void:
	$Player.scale.x = 1.2
	$Gun.scale.y = $Gun.scale_gun
	#rotation_degrees = 0
	flip_h = false

@rpc("any_peer", "call_local")
func health_label():	
	if is_multiplayer_authority():
		$CanvasLayer/health/Label.text = str(health)
		$CanvasLayer/health.value = health
		$CanvasLayer/health.max_value = max_health

func _enter_tree():
	set_multiplayer_authority(name.to_int())

func update_rotation():
	$Gun.rotation_degrees = wrap($Gun.rotation_degrees, 0, 360)
	if $Gun.rotation_degrees > 90 and $Gun.rotation_degrees < 270:
		_on_gun_left()
		
	else:
		_on_gun_right()

func blinking():
	blinking_timer.wait_time = randi_range(3, 20)
	blinking_timer.one_shot = true
	blinking_timer.start()
	
func _on_blinking_timeout() -> void:
	$Player/polygons/head/AnimatedSprite2D.play("default")
	blinking()

func animate_legs(delta: float) -> void:
	walk_cycle_time += delta * walk_speed

	var leg_angle = sin(walk_cycle_time) * 15

	leg_left.rotation_degrees = leg_angle
	leg_right.rotation_degrees = -leg_angle

func reset_leg_positions() -> void:
	leg_left.rotation_degrees = 0
	leg_right.rotation_degrees = 0

@rpc("any_peer", "call_local")
func reset_round():
	health = max_health
	player_dead = false
	polygons.visible = true
	visible = true
	$Gun.visible = true
	$CollisionShape2D.disabled = false
	$CanvasLayer/Shop.visible = false
	$CanvasLayer/health.visible = true
	
	if is_in_group("fox"):
		global_position = Global2Vs2.fox_spawn_point
		Global2Vs2.fox_death = 0
	else:
		global_position = Global2Vs2.tiger_spawn_point
		Global2Vs2.tiger_death = 0
		
	
	is_dashing = false
	dash_available = true
	speed = normal_speed
	
	$Gun.rotation_degrees = 0
	update_rotation()
	
	walk_particle.emitting = false
	reset_leg_positions()
	health_label()
	#Global2Vs2._reset_game()
