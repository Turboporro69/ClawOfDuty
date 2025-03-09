extends TextureRect
var current_value : float = 0.0

func _on_mouse_entered() -> void:
	var tween : Tween = create_tween()
	tween.tween_method(change_uniform, current_value, 1.0, 0.4)

func _on_mouse_exited() -> void:
	var tween : Tween = create_tween()
	tween.tween_method(change_uniform, current_value, 0.0, 0.4)

func change_uniform(_val : float) -> void:
	current_value = _val
	(material as ShaderMaterial).set_shader_parameter("shine", _val)
