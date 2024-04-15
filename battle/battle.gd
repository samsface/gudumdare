class_name Battle
extends Node2D

var MIN_HAND_CARDS = 2
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

enum BattleTrack {REGULAR, EGYPT, JAPAN, RUSSIA, SPAIN, BRAZIL}
@export var track: BattleTrack

@export var levels: Array[Node2D]

var t := 0.0

var battle_track_paths := {
	BattleTrack.REGULAR: "res://music/Battle Against a Suave Opponent.mp3",
	BattleTrack.EGYPT: "res://music/761374_Sand-in-my-Stop-Watch.mp3",
	BattleTrack.JAPAN: "res://music/37040_newgrounds_parago.mp3",
	BattleTrack.RUSSIA: "res://music/810727_Russian-Hardbass.mp3",
	BattleTrack.SPAIN: "res://music/333540_Latinfun.mp3",
	BattleTrack.BRAZIL: "res://music/vitaminaDeLua-By-Ausk.mp3",
}
var summon
func _ready() -> void:
	AudioControls._set_battle_position()
	Game.battle = self
	
	# some hacky bullshit to make the worm minigame work
	if levels.size() > 0:
		var keep_level = levels.pick_random()
		keep_level.visible = true
		for level in levels:
			if level != keep_level:
				level.queue_free()
		while keep_level.get_children().size() > 0:
			var item = keep_level.get_child(0)
			keep_level.remove_child(item)
			$Fight.add_child(item)
		keep_level.queue_free()
	
	mana_regen_per_sec = 0.8
	if Game.game.has_upgrade("Fast Mana 1"):
		mana_regen_per_sec *= 1.3
	if Game.game.has_upgrade("Fast Mana 2"):
		mana_regen_per_sec *= 1.4
	if Game.game.has_upgrade("Fast Mana 3"):
		mana_regen_per_sec *= 1.5
		
	if Game.game.has_upgrade("Hand Size 1"):
		MIN_HAND_CARDS += 1
	if Game.game.has_upgrade("Hand Size 2"):
		MIN_HAND_CARDS += 1
	
	#Read player cards and put them to deck
	for card in Game.game.player_cards:
		deck.push_back(load(card).instantiate())
		
	deck.shuffle()
	print("deck is " + str(deck))
	
	#Draw enough cards
	#while(true):
		#if %HandArea.get_card_children().size() >= STARTING_CARD_COUNT:
			#break
		#if deck.size() <= 0:
			#break
		#_draw_from_deck()

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
	
	summon = load("res://minigames/minigame_summon_worms/summon_worms.tscn").instantiate()
	add_child(summon)
	#summon.load_level(1)
	
	await get_tree().create_timer(0.5).timeout
	$AudioLetsGo.play()


func _process(delta: float) -> void:
	mana = move_toward(mana, max_mana, delta * mana_regen_per_sec * Game.game_speed)
	%Mana.value = mana
	%ManaWhole.value = floor(mana)
	%ManaText.text = "%s/%s" % [floor(mana), max_mana]
	
	var mouse_off = (get_local_mouse_position() - Game.SCREEN_SIZE * 0.5)
	var cam_to = mouse_off * 0.05 + Game.SCREEN_SIZE * 0.5
	var cam_angle_to = mouse_off.x * 0.00005
	%Camera2D.position = lerp(%Camera2D.position, cam_to, delta * 10.0)
	%Camera2D.rotation = lerp(%Camera2D.rotation, cam_angle_to, delta * 5.0)
	
	var show_left_zone = Game.dragging_card and Game.dragging_card.spawn_region == Game.dragging_card.SpawnRegion.LEFT and not won
	t += delta
	$SpawnZone.modulate.a = move_toward($SpawnZone.modulate.a, (0.5 + sin(t * TAU) * 0.1) if show_left_zone else 0.0, delta / 0.4)
	
	if Input.is_key_pressed(KEY_P):
		_tower_enemy_died()

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
	
	if summon.player.placed:
		%FindWorms.visible = false
	
	if won: #Otherwise %HandArea causes error because it doesnt exist anymore
		return
	if card_add_delay <= 0:
		if is_instance_valid(%HandArea) and %HandArea.get_card_children().size() < MIN_HAND_CARDS:
			_draw_from_deck()
	else:
		card_add_delay -= delta

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
		var mouse_position := get_global_mouse_position()
		#await get_tree().create_timer(0.25).timeout
		var unit = node.spawns.instantiate()
		add_unit(unit, mouse_position, node)
		mana -= node.mana_cost
		await get_tree().process_frame
		node.get_parent().remove_child(node)
		_add_to_deck(node)


func _draw_from_deck() -> void:
	if deck.size() > 0:
		var card = deck[0]
		%HandArea.add_child(card)
		card.global_position = %NewCardSpawn.global_position
		#Remove drawn card
		deck.remove_at(0)
		card_add_delay = 0.2


func _tower_enemy_died() -> void:
	# win signal is getting called twice sometimes, don't know why
	if won:
		return
	mana = max_mana
	won = true
	Game.game.battle_won = true
	
	if levels.size() > 0:
		summon.player.visible = true
		tower_player.hide_player()
		%FindWorms.visible = true
	else:
		give_card()
	
	$AudioWin.play()
	$AudioApplause.play()
	
	#$SubViewports.visible = falseif Game.game:
	Game.game.lowpass_music(true)
	
	$SubViewports/SubViewportContainer.queue_free()
	$CanvasLayer.visible = false

func _tower_player_died() -> void:
	Game.game.lowpass_music(true)
	$SubViewports/SubViewportContainer.queue_free()
	$CanvasLayer.visible = false
	var loose = load("res://battle/loose.tscn").instantiate()
	$SubViewports.add_child(loose)
	loose.done.connect(on_reward_done)

func give_card():
	var reward = load("res://battle/reward.tscn").instantiate()
	$SubViewports.add_child(reward)
	reward.done.connect(on_reward_done)
	
func on_reward_done():
	Game.game.open_overworld()

func _add_to_deck(card):
	deck.push_back(card)
