extends Area2D

@export var weapon_data : Weapons

@rpc("any_peer")
func set_weapon_data(data: Weapons) -> void:
	weapon_data = data
	$Sprite2D.texture = weapon_data.texture
	
func get_weapon_data() -> Weapons:
	return weapon_data
