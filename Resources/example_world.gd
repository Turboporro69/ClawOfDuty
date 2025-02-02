extends Node2D

@onready var bullet = preload("res://Resources/bullet.tscn")

func _ready():
	pass

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		var instance = bullet.instantiate()
		add_child(instance)
