extends Node2D

func _ready():
	$player/Camera2D/Button.disabled = true
	$player/Camera2D/Button.visible = false

func _process(delta: float) -> void:
	update_score()

func update_score():
	$player/Camera2D/Label2.text = "You: " + str(score.player_score)
	$player/Camera2D/Label3.text = "Bot: " + str(score.enemy_score)

func _on_button_pressed() -> void:
	get_tree().reload_current_scene()

func _on_player_player_death() -> void:
	death()

func _on_enemy_bot_death() -> void:
	death()

func death():
	update_score()
	show_button()

func show_button():
	$player/Camera2D/Button.disabled = false
	$player/Camera2D/Button.visible = true
