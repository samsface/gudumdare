class_name Game
extends Node2D

const SCREEN_SIZE = Vector2(1440, 810)
static var game: Game

var current_scene
var transition

var gold := 0
var souls := 0
var worms := 0

#CARD CODE
var player_cards = []

func add_card(card_name: String) -> void: #Add card by name, names are consts in CardDB
	player_cards.append(card_name)
#END OF CARD CODE
func remove_card(card_name: String): #Erase card by name, names are consts in CardDB
	player_cards.erase(card_name)

func _ready() -> void:
	game = self
	transition = %Transition
	open_overworld()
	duck_music(false)
	
	add_card(CardDB.CN_ARCHER)
	add_card(CardDB.CN_ARCHER)
	add_card(CardDB.CN_ARCHER)
	add_card(CardDB.CN_KNIGHT)
	add_card(CardDB.CN_KNIGHT)
	add_card(CardDB.CN_RAIN)
	print("game done adding cards")
	print(player_cards)

func open_overworld():
	start_scene("res://overworld/overworld.tscn")

func open_battle(scene_path):
	start_scene(scene_path)

func open_minigame(scene_path):
	start_scene(scene_path)

func open_altar():
	start_scene("res://altar/altar.tscn")


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



func play_music_overworld():
	$Music.stream = load("res://music/1226674_Rhythm-Factory.ogg")
	$Music.play()

func play_music_battle(path):
	$Music.stream = load(path)
	$Music.play()

func duck_music(value: bool = true):
	var tween = create_tween()
	tween.tween_property($Music, "volume_db", linear_to_db(0.01 if value else 0.6), 0.2)

func lowpass_music(value: bool = true):
	AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("Music"), 1, value)
