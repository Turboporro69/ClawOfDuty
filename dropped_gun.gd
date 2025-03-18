extends Area2D

@export var weapon_data : Weapons

func _process(delta: float) -> void:
	$Sprite2D.texture = weapon_data.texture
