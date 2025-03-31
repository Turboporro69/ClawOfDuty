extends Node2D
#Center_inside
var apartments : bool = false



func _on_opacity_area_entered(area: Area2D) -> void:
	$Node2D/center1.modulate.a = 0.5
	$Node2D/center2.modulate.a = 0.5
	$Node2D/center1.z_index = 15
	$Node2D/center2.z_index = 15


func _on_opacity_area_exited(area: Area2D) -> void:
	$Node2D/center1.modulate.a = 1
	$Node2D/center2.modulate.a = 1
	$Node2D/center1.z_index = 0
	$Node2D/center2.z_index = 0
	
#Center
func _on_center_area_entered(area: Area2D) -> void:
	$Node2D/Sprite2D9.modulate.a = 0.5
	$Node2D/Sprite2D11.modulate.a = 0.5
	$Node2D/Sprite2D12.modulate.a = 0.5
	$Node2D/Sprite2D13.modulate.a = 0.5
	$Node2D/Sprite2D14.modulate.a = 0.5
	$Node2D/Sprite2D9.z_index = 15
	$Node2D/Sprite2D11.z_index = 15
	$Node2D/Sprite2D12.z_index = 15
	$Node2D/Sprite2D12.z_index = 15
	$Node2D/Sprite2D14.z_index = 15
	

func _on_center_area_exited(area: Area2D) -> void:
	$Node2D/Sprite2D9.modulate.a = 1
	$Node2D/Sprite2D11.modulate.a = 1
	$Node2D/Sprite2D12.modulate.a = 1
	$Node2D/Sprite2D13.modulate.a = 1
	$Node2D/Sprite2D14.modulate.a = 1
	$Node2D/Sprite2D9.z_index = 0
	$Node2D/Sprite2D11.z_index = 0
	$Node2D/Sprite2D12.z_index = 0
	$Node2D/Sprite2D13.z_index = 0
	$Node2D/Sprite2D14.z_index = 0

#aps
func _on_apartments_area_entered(area: Area2D) -> void:
	$Node2D/Sprite2D3.modulate.a = 0.5
	$Node2D/Sprite2D2.modulate.a = 0.5
	$Node2D/Sprite2D2.z_index = 15
	$Node2D/Sprite2D3.z_index = 15


func _on_apartments_area_exited(area: Area2D) -> void:
	$Node2D/Sprite2D3.modulate.a = 1
	$Node2D/Sprite2D2.modulate.a = 1
	$Node2D/Sprite2D2.z_index = 0
	$Node2D/Sprite2D3.z_index = 0


func _on_library_area_entered(area: Area2D) -> void:
	$Node2D/Sprite2D4.modulate.a = .5
	$Node2D/Sprite2D5.modulate.a = .5
	$Node2D/Sprite2D6.modulate.a = .5
	$Node2D/Sprite2D7.modulate.a = .5
	$Node2D/Sprite2D4.z_index = 15
	$Node2D/Sprite2D5.z_index = 15
	$Node2D/Sprite2D6.z_index = 15
	$Node2D/Sprite2D7.z_index = 15

func _on_library_area_exited(area: Area2D) -> void:
	$Node2D/Sprite2D4.modulate.a = 1
	$Node2D/Sprite2D5.modulate.a = 1
	$Node2D/Sprite2D6.modulate.a = 1
	$Node2D/Sprite2D7.modulate.a = 1
	$Node2D/Sprite2D4.z_index = 0
	$Node2D/Sprite2D5.z_index = 0
	$Node2D/Sprite2D6.z_index = 0
	$Node2D/Sprite2D7.z_index = 0
