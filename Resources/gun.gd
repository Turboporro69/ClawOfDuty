extends Node2D
@onready var pewpew = $pewpew
@onready var bullet_scene = preload("res://Resources/bullet.tscn")
@onready var marker_2d: Marker2D = $Marker2D
@export var scale_gun: float 
@onready var selected_material = preload("res://shaders/selected_gun_material.tres")
@onready var not_selected_material = preload("res://shaders/not_selected_gun_material.tres")
@onready var dropped_weapon = preload("res://dropped_gun.tscn")
var pewpewcooldown = true
var moving = false
var drift
var cadence : float
var feet_position
var near_weapon : Area2D = null
var weapon_data
var weapon_category

# If for any reason you want to read this, don't do it. I don't even know why or how works uwu

@export var primary_selected : bool = false
@export var secondary_selected : bool = false
@export var melee_selected : bool = false
var current_weapon : String

var automatic : bool = false
var damage = 10

@export var primary_weapon : Weapons:
	set(value):
		primary_weapon = value
		load_weapon()
@export var secondary_weapon : Weapons:
	set(value):
		secondary_weapon = value
		load_weapon()

func _ready() -> void:
	if primary_weapon == null and secondary_weapon != null:
		current_weapon = "secondary"
	elif primary_weapon != null:
		current_weapon = "primary"
	else:
		current_weapon = "melee"
	load_weapon()
	update_weapon_icons()
	selected()

func _process(delta: float) -> void:
	if is_multiplayer_authority():
		pick_weapon()
		drop_weapon()
		rotation_degrees = wrap(rotation_degrees, 0, 360)
		#rotation()

		var jambo = get_parent()
		if jambo.velocity.length() > 0:
			moving = true
		else:
			moving = false

		if automatic:
			if Input.is_action_pressed("shoot") and pewpewcooldown == true:
				shoot.rpc()
		else:
			if Input.is_action_just_pressed("shoot") and pewpewcooldown == true:
				shoot.rpc()
		
		selected()
		change_weapon()
		load_weapon()
		

		if current_weapon == "primary" and primary_weapon == null:
			if secondary_weapon != null:
				current_weapon = "secondary"
			else:
				current_weapon = "melee"
			load_weapon()
		elif current_weapon == "secondary" and secondary_weapon == null:
			if primary_weapon != null:
				current_weapon = "primary"
			else:
				current_weapon = "melee"
			load_weapon()
			



@rpc("call_local")
func shoot():
	if is_multiplayer_authority():
		if moving == true:
			drift = deg_to_rad(randf_range(-15, 15))
		else:
			drift = deg_to_rad(randf_range(-5, 5))
		rpc("apply_recoil", drift)
	else:
		return

	pewpewcooldown = false
	pewpew.start()
	var bullet = bullet_scene.instantiate()
	get_parent().add_child(bullet)
	bullet.damage = damage
	bullet.global_position = marker_2d.global_position
	bullet.rotation = rotation + drift

@rpc("call_local")
func apply_recoil(synced_drift: float):
	drift = synced_drift

func drop_weapon():
	if Input.is_action_just_pressed("drop"):
		if current_weapon == "primary" and primary_weapon !=null:
			var dropped_weapon_instance = dropped_weapon.instantiate()
			dropped_weapon_instance.weapon_data = primary_weapon
			dropped_weapon_instance.global_position = feet_position
			dropped_weapon_instance.scale = $Sprite2D.scale
			get_tree().root.add_child(dropped_weapon_instance)
			primary_weapon = null
		if current_weapon == "secondary" and secondary_weapon !=null:
			var dropped_weapon_instance = dropped_weapon.instantiate()
			dropped_weapon_instance.weapon_data = secondary_weapon
			dropped_weapon_instance.global_position = feet_position
			dropped_weapon_instance.scale = $Sprite2D.scale
			get_tree().root.add_child(dropped_weapon_instance)
			secondary_weapon = null

func _on_pick_up_area_entered(area: Area2D) -> void:
	if area.has_method("get_weapon_data"):
		near_weapon = area


func _on_pewpew_timeout() -> void:
	pewpewcooldown = true

func load_weapon():
	if current_weapon == "primary" and primary_weapon != null:
		if $Sprite2D != null:
			$Sprite2D.texture = primary_weapon.texture
		damage = primary_weapon.damage
		automatic = primary_weapon.automatic
		cadence = primary_weapon.cadence
		
		primary_selected = true
		secondary_selected = false
		melee_selected = false
	elif current_weapon == "secondary" and secondary_weapon != null:
		if $Sprite2D != null:
			$Sprite2D.texture = secondary_weapon.texture
		damage = secondary_weapon.damage
		automatic = secondary_weapon.automatic
		cadence = secondary_weapon.cadence
		
		primary_selected = false
		secondary_selected = true
		melee_selected = false
	else:
		if $Sprite2D != null:
			$Sprite2D.texture = null
		
		primary_selected = false
		secondary_selected = false
		melee_selected = true

	update_weapon_icons()
	selected()

func pick_weapon():
	if Input.is_action_just_pressed("action") and near_weapon != null:
		weapon_data = near_weapon.get_weapon_data()
		weapon_category = weapon_data.category
		if weapon_data.category == 0:
			if primary_weapon != null:
				var dropped_weapon_instance = dropped_weapon.instantiate()
				dropped_weapon_instance.weapon_data = primary_weapon
				dropped_weapon_instance.global_position = feet_position
				dropped_weapon_instance.scale = $Sprite2D.scale
				get_tree().root.add_child(dropped_weapon_instance)
				primary_weapon = null
			primary_weapon = weapon_data
			current_weapon = "primary"
		elif weapon_data.category == 1:
			if secondary_weapon != null:
				var dropped_weapon_instance = dropped_weapon.instantiate()
				dropped_weapon_instance.weapon_data = secondary_weapon
				dropped_weapon_instance.global_position = feet_position
				dropped_weapon_instance.scale = $Sprite2D.scale
				get_tree().root.add_child(dropped_weapon_instance)
				secondary_weapon = null
			secondary_weapon = weapon_data
			current_weapon = "secondary"
		near_weapon.queue_free()

func update_weapon_icons():
	if $CanvasLayer/Gun_UI/VBoxContainer/PrimaryWeapon != null:
		if primary_weapon != null:
			$CanvasLayer/Gun_UI/VBoxContainer/PrimaryWeapon.texture = primary_weapon.icon
		else:
			$CanvasLayer/Gun_UI/VBoxContainer/PrimaryWeapon.texture = null

	if $CanvasLayer/Gun_UI/VBoxContainer/SecondaryWeapn != null:
		if secondary_weapon != null:
			$CanvasLayer/Gun_UI/VBoxContainer/SecondaryWeapn.texture = secondary_weapon.icon
		else:
			$CanvasLayer/Gun_UI/VBoxContainer/SecondaryWeapn.texture = null

func change_weapon():
	if Input.is_action_just_pressed("primary_weapon") and primary_weapon != null:
		current_weapon = "primary"
		load_weapon()
	elif Input.is_action_just_pressed("secondary_weapon") and secondary_weapon != null:
		current_weapon = "secondary"
		load_weapon()
	elif Input.is_action_just_pressed("melee"):
		current_weapon = "melee"
		load_weapon()

func selected():
	if $CanvasLayer/Gun_UI/VBoxContainer/PrimaryWeapon != null:
		if primary_selected == true:
			$CanvasLayer/Gun_UI/VBoxContainer/PrimaryWeapon.material = selected_material
		else:
			$CanvasLayer/Gun_UI/VBoxContainer/PrimaryWeapon.material = not_selected_material
	
	if $CanvasLayer/Gun_UI/VBoxContainer/SecondaryWeapn != null:
		if secondary_selected == true:
			$CanvasLayer/Gun_UI/VBoxContainer/SecondaryWeapn.material = selected_material
		else:
			$CanvasLayer/Gun_UI/VBoxContainer/SecondaryWeapn.material = not_selected_material
	
	if $CanvasLayer/Gun_UI/VBoxContainer/Melee != null:
		if melee_selected == true:
			$CanvasLayer/Gun_UI/VBoxContainer/Melee.material = selected_material
		else:
			$CanvasLayer/Gun_UI/VBoxContainer/Melee.material = not_selected_material


func _on_pick_up_area_exited(area: Area2D) -> void:
	near_weapon = null
