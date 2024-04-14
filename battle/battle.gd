class_name Battle
extends Node2D

const MIN_HAND_CARDS = 3
const STARTING_CARD_COUNT = 5

var hand := []
var deck := []

var units := []
var friends := []
var foes := []

var card_add_delay := 0.0

var won := false

@onready var tower_player = %TowerPlayer
@onready var tower_enemy = %TowerEnemy

var mana := 0.0
var max_mana := 10
var mana_regen_per_sec := 1.0

enum BattleTrack {REGULAR, EGYPT, JAPAN, RUSSIA, SPAIN}
@export var track: BattleTrack

var battle_track_paths := {
	BattleTrack.REGULAR: "res://music/Battle Against a Suave Opponent.mp3",
	BattleTrack.EGYPT: "res://music/761374_Sand-in-my-Stop-Watch.mp3",
	BattleTrack.JAPAN: "res://music/37040_newgrounds_parago.mp3",
	BattleTrack.RUSSIA: "res://music/810727_Russian-Hardbass.mp3",
	BattleTrack.SPAIN: "res://music/333540_Latinfun.mp3",
}

func _ready() -> void:
	randomize()
	#Read player cards and put them to deck
	for card_name in Game.game.player_cards:
		_add_to_deck(card_name) 
		
	deck.shuffle()
	print("deck is " + str(deck))
	
	#Draw enough cards
	while(true):
		if %HandArea.get_card_children().size() >= STARTING_CARD_COUNT:
			break
		if deck.size() <= 0:
			break
		_draw_from_deck()

	tower_player.battle = self
	friends.push_back(tower_player)
	units.push_back(tower_player)
	
	tower_enemy.battle = self
	foes.push_back(tower_enemy)
	units.push_back(tower_enemy)
	
	%HandArea.battle = self
	%Mana.max_value = max_mana
	%ManaText.text = "%s/%s" % [mana, max_mana]
	%ManaWhole.max_value = max_mana
	Game.game.play_music_battle(battle_track_paths[track])
	await get_tree().create_timer(0.5).timeout
	$AudioLetsGo.play()
	


func _process(delta: float) -> void:
	mana = move_toward(mana, max_mana, delta * mana_regen_per_sec)
	%Mana.value = mana
	%ManaWhole.value = floor(mana)
	
	var mouse_off = (get_local_mouse_position() - Game.SCREEN_SIZE * 0.5)
	var cam_to = mouse_off * 0.05 + Game.SCREEN_SIZE * 0.5
	var cam_angle_to = mouse_off.x * 0.00005
	%Camera2D.position = lerp(%Camera2D.position, cam_to, delta * 10.0)
	%Camera2D.rotation = lerp(%Camera2D.rotation, cam_angle_to, delta * 5.0)

func _physics_process(delta: float) -> void:
	for i in units.size():
		for j in range(i + 1, units.size()):
			var unit_a: Unit = units[i]
			var unit_b: Unit = units[j]
			var radius = unit_a.radius + unit_b.radius
			var distance = unit_a.position.distance_squared_to(unit_b.position)
			if distance < radius * radius:
				distance = sqrt(distance)
				var push = (radius - distance) * 10.0
				var ratio = unit_a.weight / unit_b.weight
				if ratio > 1.0:
					ratio = 1.0 / ratio
				var direction = unit_a.position.direction_to(unit_b.position)
				unit_a.position -= direction * push * ratio * delta
				unit_b.position += direction * push * (1.0 - ratio) * delta

func get_card_position(card):
	if not hand.has(card):
		return Vector2(0, 200.0)
	var padding := 200.0
	return Vector2((hand.find(card) - (hand.size() - 1) * 0.5) * padding, 0)

func add_unit(unit: Unit, position: Vector2, card = null):
	unit.battle = self
	unit.position = position
	unit.card = card
	%Fight.add_child(unit)
	if unit.is_foe:
		foes.push_back(unit)
	else:
		friends.push_back(unit)
	units.push_back(unit)


func _on_button_quit_pressed() -> void:
	Game.game.open_overworld()

func card_rejected():
	get_global_mouse_position()

#We use this now
func _battle_field_area_child_entered_tree(node: Node) -> void:
	if node is CardEx:
		_add_to_deck(node.card_name)
		var mouse_position := get_global_mouse_position()
		#await get_tree().create_timer(0.25).timeout
		var unit = node.spawns.instantiate()
		add_unit(unit, mouse_position, node)
		mana -= node.mana_cost

		if %HandArea.get_card_children().size() < MIN_HAND_CARDS:
			_draw_from_deck()
			
func _draw_from_deck() -> void:
	if deck.size() > 0:
		var card_name: String = deck[0]
		var new_card: Node3D = CardDB.return_card_scene(card_name).duplicate()
		%HandArea.add_child(new_card)
		new_card.global_position = %NewCardSpawn.global_position
		#Remove drawn card
		deck.remove_at(0)


func _tower_enemy_died() -> void:
	# win signal is getting called twice sometimes, don't know why
	if won:
		return
	
	won = true
	
	var reward = load("res://battle/reward.tscn").instantiate()
	
	$AudioWin.play()
	$AudioApplause.play()
	
	$SubViewports.add_child(reward)
	$SubViewports/SubViewportContainer.queue_free()
	$CanvasLayer.visible = false

	reward.done.connect(_on_button_quit_pressed)

func _add_to_deck(card_name: String):
	deck.push_back(card_name)
