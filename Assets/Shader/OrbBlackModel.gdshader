// NOTE: Shader automatically converted from Godot Engine 3.5.rc2's SpatialMaterial.

shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_disabled,diffuse_burley,specular_schlick_ggx;
uniform vec4 albedo : hint_color;
uniform vec4 paint_color : hint_color;
uniform vec4 mountain_color_upper : hint_color;
uniform vec4 mountain_color_lower : hint_color;
uniform sampler2D texture_albedo : hint_albedo;
uniform sampler2D texture_rivers : hint_albedo;
uniform float specular;
uniform float metallic;
uniform float roughness : hint_range(0,1);
uniform float point_size : hint_range(0,128);
uniform sampler2D texture_emission : hint_black_albedo;
uniform vec4 emission : hint_color;
uniform float emission_energy;
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;
varying vec4 wrld_vertex;

uniform float paint_value : hint_range(0,1);
uniform float mountain_value : hint_range(0,1);
uniform float river_value : hint_range(0,1);

void vertex() {
	UV=UV*uv1_scale.xy+uv1_offset.xy;
	wrld_vertex = CAMERA_MATRIX * vec4(VERTEX, 1.0);
	wrld_vertex = vec4(VERTEX, 1.0);
	vec4 river_tex = texture(texture_rivers,UV);
	VERTEX = VERTEX * (1.0 + .35* mountain_value *river_tex.r);
	VERTEX = VERTEX * (1.0 - .25* river_value *river_tex.b);
}

float clamp_and_map(float value, float istart, float istop, float ostart, float ostop) {
    value = clamp(value, istart, istop);
    return ostart + (ostop - ostart) * ((value - istart) / (istop - istart));
}

void fragment() {
	vec2 base_uv = UV;
	vec4 albedo_tex = texture(texture_albedo,base_uv);
	vec4 river_tex = texture(texture_rivers,base_uv);
	albedo_tex *= COLOR;
	float paint_adder = -1.1 + 3.5*paint_value;
	float albedo_mask= clamp(wrld_vertex.x + paint_adder, 0.0, 1.0);
	float inv_paint = 1.0 - paint_value;
	
	ALBEDO = albedo.rgb * albedo_tex.rgb;
	
	ALBEDO = mix(ALBEDO, paint_color.rgb, albedo_mask);
	
	vec3 mountain_color = mix(mountain_color_upper, mountain_color_lower, clamp_and_map(river_tex.r, .4, .65, 1.0, 0.0) ).rgb;
	
	ALBEDO = mix(ALBEDO, mountain_color.rgb, mountain_value * mountain_value * clamp_and_map(river_tex.r, .07, .2, 0.0, 1.0));
	
	METALLIC = mix(metallic, 0.0, albedo_mask);
	ROUGHNESS = mix(roughness, 1.0, albedo_mask);
	vec3 emission_tex = mix(texture(texture_emission,base_uv).rgb, vec3(0.0), albedo_mask);
	EMISSION = mix((emission.rgb*emission_tex)*emission_energy, vec3(0.0), albedo_mask);
}
