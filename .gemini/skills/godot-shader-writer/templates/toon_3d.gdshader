shader_type spatial;

uniform vec4 base_color : source_color = vec4(0.8, 0.2, 0.2, 1.0);
uniform float shade_threshold : hint_range(0.0, 1.0) = 0.5;
uniform float shade_softness : hint_range(0.0, 0.5) = 0.05;
uniform vec4 shade_color : source_color = vec4(0.3, 0.1, 0.1, 1.0);

void fragment() {
    ALBEDO = base_color.rgb;
    ROUGHNESS = 1.0;
    METALLIC = 0.0;
}

void light() {
    float NdotL = dot(NORMAL, LIGHT);
    float shading = smoothstep(shade_threshold - shade_softness, shade_threshold + shade_softness, NdotL);
    DIFFUSE_LIGHT += mix(shade_color.rgb, base_color.rgb, shading) * ATTENUATION * LIGHT_COLOR;
}
