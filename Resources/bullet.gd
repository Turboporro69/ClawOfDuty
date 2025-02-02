extends Area2D
var speed = 5
var velocity = Vector2()

func _ready():
	velocity = Vector2(speed,0)
	position.y = 20
	

func _process(delta):
	translate(velocity)
	await get_tree().create_timer(10).timeout
	queue_free()
