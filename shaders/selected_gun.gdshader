shader_type canvas_item;

uniform float shadow_size = 2.5;
uniform vec2 shadow_offset = vec2(0.01, 0.01);
uniform vec4 shadow_color = vec4(0.0, 0.0, 0.0, 0.5);
uniform int sample_count = 64;

void fragment() {
    vec4 input_color = texture(TEXTURE, UV);

    vec4 shadow = vec4(0.0);

    for (int i = 0; i < sample_count; i++) {
        float angle = float(i) / float(sample_count) * 6.283185;
        vec2 offset = vec2(cos(angle), sin(angle)) * shadow_offset * shadow_size;
        shadow += texture(TEXTURE, UV + offset) * shadow_color;
    }

    shadow /= float(sample_count);

    vec4 final_color = vec4(1.0, 1.0, 1.0, input_color.a);

    COLOR = mix(shadow, final_color, input_color.a);
}
