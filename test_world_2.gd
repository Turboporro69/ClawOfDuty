extends Node2D

#func _ready() -> void:
	#$Button.show()
	#$Label.show()
	#get_tree().paused = true



func _on_button_pressed() -> void:
	$Button.hide()
	$Label.hide()
	get_tree().paused = false
