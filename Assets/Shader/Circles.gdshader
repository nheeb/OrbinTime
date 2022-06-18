shader_type spatial;
render_mode async_visible,blend_mix,depth_draw_opaque,cull_disabled,diffuse_burley,specular_schlick_ggx;
uniform vec4 albedo : hint_color;
uniform sampler2D texture_albedo : hint_albedo;
uniform float offset_time;

float clamp_and_map(float value, float istart, float istop, float ostart, float ostop) {
    value = clamp(value, istart, istop);
    return ostart + (ostop - ostart) * ((value - istart) / (istop - istart));
}

void fragment() {
	float ring_pos = mod(-TIME * .1 + offset_time, .5);
	float dist = abs(UV.y - ring_pos);
	ALPHA = pow(clamp_and_map(dist, 0.0, 0.01, .45, 0.0), 2.0) * albedo.a * pow(clamp_and_map(ring_pos, .25, .5, 0.0, 1.0), 1.0);
	ALBEDO = albedo.rgb;
	EMISSION = 3.0*ALBEDO;
}
