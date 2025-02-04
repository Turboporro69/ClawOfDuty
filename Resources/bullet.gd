extends Area2D

var speed = 700
var bullet_direction

func _process(delta):
	position -= bullet_direction * speed * delta
	pass
