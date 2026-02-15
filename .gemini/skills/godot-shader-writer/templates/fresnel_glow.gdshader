shader_type spatial;
render_mode unshaded;

uniform vec4 glow_color : source_color = vec4(0.3, 0.6, 1.0, 1.0);
uniform float fresnel_power : hint_range(0.0, 10.0) = 3.0;
uniform float glow_intensity : hint_range(0.0, 5.0) = 1.5;
uniform vec4 base_color : source_color = vec4(0.1, 0.1, 0.15, 1.0);

void fragment() {
    float fresnel = pow(1.0 - dot(NORMAL, VIEW), fresnel_power);
    ALBEDO = mix(base_color.rgb, glow_color.rgb * glow_intensity, fresnel);
    ALPHA = mix(base_color.a, 1.0, fresnel);
}
