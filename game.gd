class_name Game
extends Node2D

const SCREEN_SIZE = Vector2(1440, 810)
static var game: Game

var current_scene

func _ready() -> void:
	game = self
	open_overworld()


func open_overworld():
	start_scene("res://overworld/overworld.tscn")

func open_battle(scene_path):
	start_scene(scene_path)

func open_shop():
	start_scene("res://shop/shop.tscn")

func start_scene(path):
	%Transition.close()
	await %Transition.closed
	if current_scene:
		current_scene.queue_free()
	current_scene = load(path).instantiate()
	add_child(current_scene)
	%Transition.open()
