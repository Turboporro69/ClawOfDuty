extends Area2D


@export var health : float

func _ready() -> void:
	%ProgressBar.value = health
	%ProgressBar.max_value = health

func _process(delta: float) -> void:
	if health == 0:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	health -= 1
	%ProgressBar.value = health
	
