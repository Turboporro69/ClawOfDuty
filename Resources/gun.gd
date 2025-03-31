extends Node2D
@onready var pewpew = $pewpew
@onready var bullet_scene = preload("res://Resources/bullet.tscn")
@onready var marker_2d: Marker2D = $Marker2D
@export var scale_gun: float 
@onready var selected_material = preload("res://shaders/selected_gun_material.tres")
@onready var not_selected_material = preload("res://shaders/not_selected_gun_material.tres")
@onready var dropped_weapon = preload("res://dropped_gun.tscn")
@onready var mag_ui = $CanvasLayer/Gun_UI/HBoxContainer/Label
var pewpewcooldown = true
var moving = false
var drift
@export var primary_weapons: Array[Weapons] = []
@export var secondary_weapons: Array[Weapons] = []
var cadence : float
var feet_position
var near_weapon : Area2D = null
var weapon_data
var weapon_category
var nearby_weapons = []
var extra_recoil : int
var extra_recoil_moving : int
var reloading : bool
@onready var reload_circle = $CanvasLayer/Reload_UI/reload


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
		load_weapon.rpc("primary")
@export var secondary_weapon : Weapons:
	set(value):
		secondary_weapon = value
		load_weapon.rpc("secondary")

func _ready() -> void:
	if primary_weapon == null and secondary_weapon != null:
		load_weapon.rpc("secondary")
	elif primary_weapon != null:
		load_weapon.rpc("primary")
	else:
		load_weapon.rpc("melee")
	update_weapon_icons()
	selected()
	$CanvasLayer.visible = false

	if is_multiplayer_authority():
		$CanvasLayer.visible = true
		#assign_random_weapons.rpc()

func _process(delta: float) -> void:
	if is_multiplayer_authority():
		update_reload_ui()
		update_mag_ui()
		pick_weapon.rpc()
		rotation_degrees = wrap(rotation_degrees, 0, 360)

		var jambo = get_parent()
		if jambo.velocity.length() > 0:
			moving = true
		else:
			moving = false

		if automatic:
			if Input.is_action_pressed("shoot") and pewpewcooldown == true and current_weapon != "melee" and reloading == false:
				if current_weapon == "primary" and primary_weapon != null:
					shoot.rpc()
				elif current_weapon == "secondary" and secondary_weapon != null:
					shoot.rpc()
		else:
			if Input.is_action_just_pressed("shoot") and pewpewcooldown == true and current_weapon != "melee" and reloading == false:
				if current_weapon == "primary" and primary_weapon != null:
					shoot.rpc()
				elif current_weapon == "secondary" and secondary_weapon != null:
					shoot.rpc()

		selected()
		change_weapon()
		reload()
		$pewpew.wait_time = cadence

		if current_weapon == "primary" and primary_weapon == null:
			if secondary_weapon != null:
				load_weapon.rpc("secondary")
			else:
				load_weapon.rpc("melee")
		elif current_weapon == "secondary" and secondary_weapon == null:
			if primary_weapon != null:
				load_weapon.rpc("primary")
			else:
				load_weapon.rpc("melee")

		if Input.is_action_just_pressed("drop") and reloading == false:
			drop_weapon.rpc()

@rpc("call_local")
#func shoot():
	#if moving == true:
		#drift = deg_to_rad(randf_range(-15, 15))
	#else:
		#drift = deg_to_rad(randf_range(-5, 5))
	#pewpewcooldown = false
	#pewpew.start()
	#var bullet = bullet_scene.instantiate()
	#get_tree().root.add_child(bullet)
	#bullet.damage = damage
	#bullet.global_position = marker_2d.global_position
	#bullet.rotation = rotation + drift
func shoot():
		if current_weapon == "primary":
			extra_recoil = primary_weapon.recoil
			extra_recoil_moving = primary_weapon.recoil_moving
			if primary_weapon.name == "shotgun":
				var pellet_count = 8
				var spread_angle = 10
				for i in range(pellet_count):
					var pellet = bullet_scene.instantiate()
					get_parent().add_child(pellet)
					pellet.damage = primary_weapon.damage / 2
					pellet.global_position = marker_2d.global_position
					var angle_offset = deg_to_rad(randf_range(-spread_angle, spread_angle))
					pellet.rotation = rotation + angle_offset


					var timer = Timer.new()
					timer.wait_time = .5
					timer.one_shot = true
					timer.connect("timeout", Callable(pellet, "queue_free"))
					pellet.add_child(timer)
					timer.start()
		elif current_weapon == "secondary":
			extra_recoil = secondary_weapon.recoil
			extra_recoil_moving = secondary_weapon.recoil_moving
			
		if moving == true:
			drift = deg_to_rad(randf_range(-15-extra_recoil-extra_recoil_moving, 15+extra_recoil+extra_recoil_moving))
		elif primary_weapon != null and primary_weapon.name == "sniper":
			drift = 0
		else:
			drift = deg_to_rad(randf_range(-5-extra_recoil, 5+extra_recoil))
		rpc("apply_recoil", drift)

		pewpewcooldown = false
		pewpew.start()
		if primary_weapon != null and primary_weapon.name == "shotgun":
			pass
		else:
			var bullet = bullet_scene.instantiate()
			get_parent().add_child(bullet)
			if current_weapon == "primary":
				bullet.damage = primary_weapon.damage
				if is_multiplayer_authority():
					primary_weapon.mag_bullets -= 1
			elif current_weapon == "secondary":
				bullet.damage = secondary_weapon.damage
				if is_multiplayer_authority():
					secondary_weapon.mag_bullets -= 1
			bullet.global_position = marker_2d.global_position
			bullet.rotation = rotation + drift

@rpc("call_local")
func apply_recoil(synced_drift: float):
	drift = synced_drift
@rpc("call_local", "any_peer")
func drop_weapon():
	if feet_position == null:
		feet_position = global_position

	if current_weapon == "primary" and primary_weapon != null:
		var dropped_weapon_instance = dropped_weapon.instantiate()
		dropped_weapon_instance.weapon_data = primary_weapon
		dropped_weapon_instance.global_position = feet_position
		dropped_weapon_instance.scale = $Sprite2D.scale
		get_tree().root.add_child(dropped_weapon_instance)
		primary_weapon = null
	elif current_weapon == "secondary" and secondary_weapon != null:
		var dropped_weapon_instance = dropped_weapon.instantiate()
		dropped_weapon_instance.weapon_data = secondary_weapon
		dropped_weapon_instance.global_position = feet_position
		dropped_weapon_instance.scale = $Sprite2D.scale
		get_tree().root.add_child(dropped_weapon_instance)
		secondary_weapon = null

func _on_pick_up_area_entered(area: Area2D) -> void:
	if area.has_method("get_weapon_data"):
		nearby_weapons.append(area)
		if near_weapon == null:
			near_weapon = area


func _on_pewpew_timeout() -> void:
	pewpewcooldown = true


@rpc("call_local")
func load_weapon(new_weapon: String) -> void:
	current_weapon = new_weapon
	if new_weapon == "primary" and primary_weapon != null:
		if $Sprite2D != null:
			$Sprite2D.texture = primary_weapon.texture
			$Sprite2D.scale.x = primary_weapon.sprite_scale
			$Sprite2D.scale.y = primary_weapon.sprite_scale

		damage = primary_weapon.damage
		automatic = primary_weapon.automatic
		cadence = primary_weapon.cadence
		primary_selected = true
		secondary_selected = false
		melee_selected = false
		$Marker2D.position.x = $Sprite2D.texture.get_width() / 5
	elif new_weapon == "secondary" and secondary_weapon != null:
		if $Sprite2D != null:
			$Sprite2D.texture = secondary_weapon.texture
			$Sprite2D.scale.x = secondary_weapon.sprite_scale
			$Sprite2D.scale.y = secondary_weapon.sprite_scale

		damage = secondary_weapon.damage
		automatic = secondary_weapon.automatic
		cadence = secondary_weapon.cadence

		primary_selected = false
		secondary_selected = true
		melee_selected = false
		$Marker2D.position.x = $Sprite2D.texture.get_width() / 5
	else:
		if $Sprite2D != null:
			$Sprite2D.texture = null

		primary_selected = false
		secondary_selected = false
		melee_selected = true

	update_weapon_icons()
	selected()
		
@rpc("call_local", "any_peer")
func pick_weapon():
	if Input.is_action_just_pressed("action") and near_weapon != null and reloading == false:
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
			load_weapon.rpc("primary")
		elif weapon_data.category == 1:
			if secondary_weapon != null:
				var dropped_weapon_instance = dropped_weapon.instantiate()
				dropped_weapon_instance.weapon_data = secondary_weapon
				dropped_weapon_instance.global_position = feet_position
				dropped_weapon_instance.scale = $Sprite2D.scale
				get_tree().root.add_child(dropped_weapon_instance)
				secondary_weapon = null
			secondary_weapon = weapon_data
			load_weapon.rpc("secondary")
		near_weapon.queue_free()
		nearby_weapons.erase(near_weapon)
		near_weapon = nearby_weapons[0] if nearby_weapons.size() > 0 else null

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
	if Input.is_action_just_pressed("primary_weapon") and primary_weapon != null and reloading == false:
		load_weapon.rpc("primary")
	elif Input.is_action_just_pressed("secondary_weapon") and secondary_weapon != null and reloading == false:
		current_weapon = "secondary"
		load_weapon.rpc("secondary")
	elif Input.is_action_just_pressed("melee") and reloading == false:
		current_weapon = "melee"
		load_weapon.rpc("melee")

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
	if area in nearby_weapons:
		nearby_weapons.erase(area)
		if near_weapon == area:
			near_weapon = nearby_weapons[0] if nearby_weapons.size() > 0 else null

func reload():

	if is_multiplayer_authority():
		if primary_weapon == null:
			pass
		elif secondary_weapon == null:
			pass
		else:
			if current_weapon == "primary" and primary_weapon.mag_bullets == primary_weapon.mag_max and primary_weapon != null:
				pass
			elif current_weapon == "secondary" and secondary_weapon.mag_bullets == secondary_weapon.mag_max and secondary_weapon != null:
				pass
			else:
				if current_weapon == "primary" and primary_weapon.mag_bullets == 0 and reloading == false and primary_weapon != null or current_weapon == "primary" and reloading == false and Input.is_action_just_pressed("reload"):
					reloading = true
					$reload_timer.wait_time = primary_weapon.reload_time
					$reload_timer.start()
				if current_weapon == "secondary" and secondary_weapon.mag_bullets == 0 and reloading == false and secondary_weapon != null or current_weapon == "secondary" and reloading == false and Input.is_action_just_pressed("reload"):
					reloading = true
					$reload_timer.wait_time = secondary_weapon.reload_time
					$reload_timer.start()
		
func _on_reload_timer_timeout() -> void:
	if current_weapon == "primary" and primary_weapon != null:
		primary_weapon.mag_bullets = primary_weapon.mag_max
		reloading = false
	elif current_weapon == "secondary" and secondary_weapon != null:
		secondary_weapon.mag_bullets = secondary_weapon.mag_max
		reloading = false

func update_mag_ui():
	if current_weapon == "primary" and primary_weapon != null:
		mag_ui.text = str(primary_weapon.mag_bullets) + "/" + str(primary_weapon.mag_max)
	elif current_weapon == "secondary" and secondary_weapon != null:
		mag_ui.text = str(secondary_weapon.mag_bullets) + "/" + str(secondary_weapon.mag_max)
	else:
		mag_ui.visible = false

func update_reload_ui():
	if is_multiplayer_authority():
		if reloading == false:
			reload_circle.visible = false
		elif reloading == true:
			reload_circle.visible = true
			if current_weapon == "primary":
				$CanvasLayer/Reload_UI/reload.max_value = primary_weapon.reload_time
				$reload_timer.wait_time = primary_weapon.reload_time
			elif current_weapon == "secondary":
				$CanvasLayer/Reload_UI/reload.max_value = secondary_weapon.reload_time
				$reload_timer.wait_time = secondary_weapon.reload_time
			$CanvasLayer/Reload_UI/reload.value = $reload_timer.time_left


@rpc("call_local", "any_peer")
func assign_random_weapons():
	if primary_weapons.size() > 0:
		var random_primary = primary_weapons[randi() % primary_weapons.size()]
		primary_weapon = random_primary
	
	if secondary_weapons.size() > 0:
		var random_secondary = secondary_weapons[randi() % secondary_weapons.size()]
		secondary_weapon = random_secondary
