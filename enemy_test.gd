extends Area2D
var last_shoot_time = 0
var shoot_cooldown = 1
@onready var bullet_scene = "res://Resources/bullet.tscn"
@onready var marker_2d = $Marker2D

func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	if last_shoot_time >= shoot_cooldown:
		var bullet = bullet_scene.instantiate()
		get_tree().root.add_child(bullet)

		
		last_shoot_time = 0


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullets"):
		$Label.text = str(area.damage)
		print(area.damage)
