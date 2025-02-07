extends Area2D

var player = null
@export var health : float
@onready var bullet_scene = preload("res://Resources/bullet.tscn")
var last_shot_time = 0.0 
@export var cooldown_time : float = 3.0

func _ready() -> void:
	player = get_node("../player")
	$RayCast2D.add_exception(self)
	%ProgressBar.value = health
	%ProgressBar.max_value = health

func _process(delta: float) -> void:
	if health == 0:
		queue_free()
	
	last_shot_time += delta
	
	if last_shot_time >= cooldown_time:
		shoot()

func shoot():
	var bullet = bullet_scene.instantiate()
	get_tree().root.add_child(bullet)
	bullet.global_position = global_position
	bullet.rotation = rotation
	
	last_shot_time = 0.0

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullets"):
		health -= 1
		%ProgressBar.value = health
