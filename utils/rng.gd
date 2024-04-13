class_name RNG extends Node

static var rng := RandomNumberGenerator.new()

func _ready() -> void:
	randomize()
	rng.randomize()
	
static func random_int(a, b):
	return rng.randi_range(a, b)
