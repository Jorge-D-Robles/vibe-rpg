shader_type canvas_item;

uniform float outline_width : hint_range(0.0, 10.0) = 1.0;
uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
    vec4 col = texture(TEXTURE, UV);
    float alpha = col.a;

    // Sample neighbors
    vec2 size = TEXTURE_PIXEL_SIZE * outline_width;
    float a = texture(TEXTURE, UV + vec2(-size.x, 0)).a;
    a += texture(TEXTURE, UV + vec2(size.x, 0)).a;
    a += texture(TEXTURE, UV + vec2(0, -size.y)).a;
    a += texture(TEXTURE, UV + vec2(0, size.y)).a;

    // Diagonal samples for smoother outline
    a += texture(TEXTURE, UV + vec2(-size.x, -size.y)).a;
    a += texture(TEXTURE, UV + vec2(size.x, -size.y)).a;
    a += texture(TEXTURE, UV + vec2(-size.x, size.y)).a;
    a += texture(TEXTURE, UV + vec2(size.x, size.y)).a;

    if (alpha < 0.1 && a > 0.0) {
        COLOR = outline_color;
    } else {
        COLOR = col;
    }
}
