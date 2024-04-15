class_name Game
extends Node2D

const SCREEN_SIZE = Vector2(1440, 810)
static var game: Game
static var dragging_card: CardEx
static var battle

static var game_speed := 1.0

var current_scene
var transition

static var worms := 0
static var worm_added := 0.0
@onready var worm_icon = %WormIcon
var worms_shown := 0
var worms_wait_add := 0.0

#Overworld nodes
@onready var battle_won := false
@onready var unlocked_nodes: Array = ["Czechia"]
var current_battle_node_name: String

#CARD CODE
var player_cards = []

func add_card(card_name: String) -> void: #Add card by name, names are consts in CardDB
	player_cards.append(card_name)

func remove_card(card_name: String): #Erase card by name, names are consts in CardDB
	player_cards.erase(card_name)
#END OF CARD CODE

func _ready() -> void:
	game = self
	transition = %Transition
	open_overworld()
	#open_worm_summon()
	duck_music(false)
	
	#add_card(CardDB.CN_ARCHER)
	#add_card(CardDB.CN_KNIGHT)
	#add_card(CardDB.CN_SHOTGUN)
	#add_card(CardDB.CN_RAIN)
	#add_card(CardDB.CN_PROTECTOR)
	
	upgrades.push_back("More Health 1")
	upgrades.push_back("More Health 2")
	upgrades.push_back("More Health 3")
	upgrades.push_back("Fast Mana 1")
	upgrades.push_back("Fast Mana 2")
	upgrades.push_back("Fast Mana 3")
	upgrades.push_back("Hand Size 1")
	upgrades.push_back("Hand Size 2")
	
	add_card(CardDB.CN_ARM)
	add_card(CardDB.CN_DRAGON)
	add_card(CardDB.CN_WIZARD)
	add_card(CardDB.CN_LASER)
	add_card(CardDB.CN_KNIGHT2)
	
	%WormCount.text = str(0)

func open_overworld():
	start_scene("res://overworld/overworld.tscn")

func open_battle(scene_path, node_name):
	current_battle_node_name = node_name #Read by Overworld on _ready(), we can give it special POP anim or something
	start_scene(scene_path)

func open_minigame(scene_path):
	start_scene(scene_path)

func open_altar():
	start_scene("res://altar/altar.tscn")

func open_shop():
	start_scene("res://shop/shop.tscn")

func open_worm_summon():
	start_scene("res://minigames/minigame_summon_worms/minigame_summon_worms.tscn")

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

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	if Input.is_action_just_pressed("mute"):
		AudioServer.set_bus_mute(0, not AudioServer.is_bus_mute(0))
	
	worm_added += delta
	
	
	var difference = worms - worms_shown
	if difference > 0:
		%WormCountAdd.text = "+%s" % difference
		%WormCountAdd.modulate = Color("86ba17")
	elif difference < 0:
		%WormCountAdd.text = "%s" % difference
		%WormCountAdd.modulate = Color("ea0050")
	else:
		%WormCountAdd.text = ""
	
	if difference != 0:
		if worms_wait_add > 0:
			worms_wait_add -= delta
		else:
			worms_shown = move_toward(worms_shown, worms, 1)
			%WormCount.text = str(worms_shown)
	

static func add_worm(value := 1):
	worms += value
	game.worms_wait_add = 1.0

var upgrades := []
func unlock_upgrade(upgrade):
	upgrades.push_back(upgrade)

func has_upgrade(upgrade):
	return upgrades.has(upgrade)


func _on_button_pressed() -> void:
	var bus = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_mute(bus, not AudioServer.is_bus_mute(bus))
