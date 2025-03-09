shader_type canvas_item;

void fragment() {
	vec4 input_color = texture(TEXTURE, UV);
	COLOR = vec4(0.4235, 0.4157, 0.4039, input_color.a);
}