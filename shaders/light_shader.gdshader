shader_type canvas_item;

void fragment() {
    // La luz que afectará el sprite
    vec4 light = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0);
    
    // Solo muestra el sprite donde la luz esté presente
    if (light.rgb == vec3(0.0)) {
        discard;  // Oculta el sprite si no hay luz
    }
    
    COLOR = texture(TEXTURE, UV);
}
