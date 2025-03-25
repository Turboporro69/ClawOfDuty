extends Area2D

var speed = 500
var damage : int

func _ready():
	add_to_group("bullets")

func _process(delta: float) -> void:
	position += transform.x * speed * delta
 
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullets"):
		pass
	else:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if !is_multiplayer_authority():
		return
	if body.is_in_group("enemies"):
		body.apply_damage(damage)
		queue_free()
