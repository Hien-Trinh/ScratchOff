shader_type canvas_item;

// This lets us pass the MaskViewport in from the Inspector
uniform sampler2D mask_texture;

void fragment() {
	vec4 foil = texture(TEXTURE, UV);
	vec4 mask = texture(mask_texture, UV);
	
	COLOR = foil;
	// Subtract the mask's red from the foil's alpha
	COLOR.a = clamp(foil.a - mask.r, 0.0, 1.0);
}