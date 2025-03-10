extends CharacterBody2D

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

func _ready():
	$Sprite2D.visible = true
	$Gun/Sprite2D.visible = true
	$CollisionShape2D.disabled = false

func _physics_process(delta: float) -> void:
	if health == 0 and not player_dead:
		player_dead = true
		$Sprite2D.visible = false
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
	$Camera2D/Label.text = "<3: " + str(health) + "/3"
