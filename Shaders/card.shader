shader_type canvas_item;

const vec2 center = vec2(0.5);
const float center_mod = 0.8;
const float center_gap = 1.0 - center_mod;

uniform vec2 card_uv = vec2(0.5,0.5);
uniform vec4 color_light:hint_color;
uniform vec4 color_dark:hint_color;


vec4 apply_color(vec2 uv, vec4 color) {
	
	vec4 color_mix = vec4(1.0);
	float value_mix = 1.0 * (uv.x - center.x) * (card_uv.x - center.x);
	
	if (value_mix >= 0.0) { // if mouse is on our uv side
		color_mix = color_light;
	}
	else { // if mouse is not on our uv side
		color_mix = color_dark;
	}
	return mix(color,color_mix,abs(value_mix));
}


vec2 apply_transform(vec2 uv) {
	
	vec2 trans_uv = uv;
	float value_mix = 2.0 * (uv.x - center.x) * (card_uv.x - center.x);
	float disp_mod_y = center_mod + center_gap * value_mix;
	float disp_mod_x = center_mod - center_gap * pow(abs(value_mix),2.0);
	trans_uv = (trans_uv - center) / vec2(disp_mod_x,disp_mod_y) + center;
	return trans_uv;
}


float get_uv_alpha(vec2 uv) {
	if (max(uv.x,uv.y) > 1.0) {
		return 0.0;
	}
	if (min(uv.x,uv.y) < 0.0) {
		return 0.0;
	}
	return 1.0;
}


void fragment() {
	
	vec2 uv = apply_transform(UV);
	
	COLOR = texture(TEXTURE,uv);
	COLOR = apply_color(uv,COLOR);
	COLOR.a = get_uv_alpha(uv);
	
	
}
