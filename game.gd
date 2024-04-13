class_name Game
extends Node2D

const SCREEN_SIZE = Vector2(1440, 810)
static var game: Game

var current_scene
var transition

var gold := 0
var souls := 0
var worms := 0

func _ready() -> void:
	game = self
	transition = %Transition
	open_overworld()


func open_overworld():
	start_scene("res://overworld/overworld.tscn")

func open_battle(scene_path):
	start_scene(scene_path)

func open_minigame(scene_path):
	start_scene(scene_path)

func open_shop():
	start_scene("res://shop/shop.tscn")

func start_scene(path):
	transition.close()
	await transition.closed
	if current_scene:
		current_scene.queue_free()
	current_scene = load(path).instantiate()
	add_child(current_scene)
	transition.open()
