extends Area2D

var bomb = true

func _ready() -> void:
	$Timer.start()

func _process(delta: float) -> void:
	pass

func bomb_defused():
	pass

func _on_timer_timeout() -> void:
	Global2Vs2.fox_score += 1
