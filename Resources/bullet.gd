extends Area2D

var speed = 700

func _ready():
	add_to_group("bullets")

func _process(delta: float) -> void:
	position += transform.x * speed * delta
 
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
