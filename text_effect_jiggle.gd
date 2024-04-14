@tool
class_name RichTextJiggle
extends RichTextEffect

var bbcode = "jiggle"
var rand: RandomNumberGenerator = RandomNumberGenerator.new()


func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var offset = char_fx.transform.origin - Vector2(- 30.0, 35.0)
	
	var amp = char_fx.env.get("amp", 1.0)
	var freq = char_fx.env.get("freq", 1.0)
	
	rand.seed = char_fx.glyph_index + char_fx.glyph_count
	
	var elapsed = char_fx.elapsed_time
	
	var angle = sin(elapsed * rand.randf_range(2.0, 16.0) * freq + char_fx.glyph_index)
	angle *= 0.05 * amp
	char_fx.offset = Vector2.from_angle(- elapsed * rand.randf_range(- 8.0, 8.0) * freq + char_fx.glyph_index * 0.8)
	char_fx.offset *= Vector2(0.5, 0.8) * amp
	
	var intro_offset = Vector2.from_angle(elapsed * 10.0 - char_fx.relative_index * 1.6) * 5.0
	intro_offset *= ease(clamp(1.0 - elapsed * 2.0 + char_fx.relative_index * 0.05, 0.0, 1.0), 2.0)
	
	angle += intro_offset.x * 0.1
	
	#1.0 + ease(elapsed * 7.0 - char_fx.relative_index * 0.2, 3.0) * 30.0
	
	var scale_angle = elapsed * 7.0 - char_fx.relative_index * 0.2
	
	
	var scale_strength = max(1.0 - elapsed * 0.9, 0.0) * 2.0
	scale_strength *= scale_strength
	
	var scale = Vector2.ONE * (1.0 - sin(scale_angle * PI) * 0.2 * scale_strength )
	scale *= clamp(scale_angle, 0, 1)
	
	char_fx.transform.origin -= offset
	char_fx.transform = char_fx.transform.rotated(angle)
	char_fx.transform = char_fx.transform.scaled(scale)
	char_fx.transform.origin += offset
	char_fx.transform.origin += intro_offset
	
	return true
