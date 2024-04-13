extends AnimatedSprite2D

const ANIM_DEFAULT = "default"
const ANIM_APPEAR = "appear"


func _ready() -> void:
	play(ANIM_DEFAULT)
	
	if RNG.random_int(0,1) == 1:
		flip_h = true

func reveal() -> void:
	play(ANIM_APPEAR)
