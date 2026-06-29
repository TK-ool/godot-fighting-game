shader_type canvas_item;

uniform vec4 tint : source_color = vec4(1.0);
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
	// letzte zeile is blur amount
	vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV, 0.5);
	//mix background mit der tint farbe
	color = mix(color, tint, 0.4);
	
	// makes the color "stronger", vec 4 ist ein grauton?
	color = mix(vec4(0.5),color, 1.2);
	
	COLOR = color;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
