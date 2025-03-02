extends Control
@onready var main = $Main
@onready var vs1 = $vs1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main.visible = true
	vs1.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	main.visible = false
	vs1.visible = true



func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://test_world_2.tscn")


func _on_button_bot_pressed() -> void:
	score.enemy_score = 0
	score.player_score = 0
	get_tree().change_scene_to_file("res://Resources/example_world.tscn")


func _on_host_pressed() -> void:
	pass
	

func _on_join_pressed() -> void:
	pass
