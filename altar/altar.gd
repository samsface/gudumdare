extends Control

const TIER_1 = 1
const TIER_2 = 2
const TIER_3 = 3
const REQUIRED_SACRIFICE_COUNT = 2

@onready var player_hand = $CardLayer/SubViewportContainer/SubViewport/HandTest/PlayerHand
@onready var sacrifice_button := $TopPlayer/SacrificeButton
@onready var new_card := $TopPlayer/NewCard
@onready var new_card_label := $TopPlayer/NewCard/Label
@onready var new_card_image := $TopPlayer/NewCard/Image
@onready var sacrifice_slot := $CardLayer/SubViewportContainer/SubViewport/HandTest/SacrificeSlot
@onready var tier_odds := %TierOdds

var tier1_chance: int
var tier2_chance: int
var tier3_chance: int

var filled := 0.0

func _ready() -> void:
	AudioServer.set_bus_mute(3, true)
	#Signals
	sacrifice_slot.card_dropped.connect(_check_sacrifice_button)
	player_hand.card_dropped.connect(_check_sacrifice_button)
	#Hide stuff
	new_card.hide()
	tier_odds.hide()
	#Funcs
	_check_sacrifice_button()
	#Read and add player cards to PlayerHand
	for card_path in Game.game.player_cards:
		var card_scene = load(card_path).instantiate()
		player_hand.add_child(card_scene)
	
func _check_sacrifice_button():
	print(str(sacrifice_slot.get_card_children().size()))
	
	if sacrifice_slot.get_card_children().size() == REQUIRED_SACRIFICE_COUNT:
		sacrifice_button.disabled = false
		_calculate_tier_odds()
		tier_odds.show()
	else:
		sacrifice_button.disabled = true
		tier_odds.hide()
		
func _calculate_tier_odds() -> void:
	var lowest_tier := 999 
	var highest_tier := TIER_1
	var tiers: Array = []
	
	#Reset tier chances
	tier1_chance = 0
	tier2_chance = 0
	tier3_chance = 0
	
	for card in sacrifice_slot.get_card_children():
		tiers.append(card.tier)
		if card.tier < lowest_tier:
			lowest_tier = card.tier
		elif card.tier > highest_tier:
			highest_tier = card.tier
	
	if lowest_tier == highest_tier: #BOTH cards are SAME TIER 
		match lowest_tier:
			TIER_1: tier2_chance = 100
			_: tier3_chance = 100
	else: #cards are DIFFERENT TIER
		if lowest_tier == TIER_1:
			if highest_tier == TIER_2: #TIER 1 and 2
				tier1_chance = 90
				tier2_chance = 10
			elif highest_tier == TIER_3: #TIER 1 and 3
				tier1_chance = 95
				tier3_chance = 5
		elif lowest_tier == TIER_2: #TIER 2 and 3
			tier2_chance = 75
			tier3_chance = 25
			
	tier_odds.text = "Tier 1 chance " + str(tier1_chance) + "%"
	tier_odds.text += "\nTier 2 chance " + str(tier2_chance) + "%"
	tier_odds.text += "\nTier 3 chance " + str(tier3_chance) + "%"
			
			
func _on_sacrifice_button_pressed() -> void:
	sacrifice_button.hide()
	%Hint.hide()
	$Sacrafice.play()
	tier_odds.hide()
	
	var tier = -1
	if tier3_chance > 0:
		if RNG.random_int(1, 100) <= tier3_chance:
			tier = 3
	if tier == -1 and tier2_chance > 0:
		if RNG.random_int(1, 100) <= tier2_chance:
			tier = 2
	if tier == -1: #Other tiers impossible or roll failed, always assign tier 1
		tier = 1
	
	var card_path = CardDB.return_cards_by_tier(tier).pick_random()
	var obtained_card = load(card_path).instantiate()
	new_card.show()
	
	new_card_label.text = "YOU GOT " + obtained_card.card_name.to_upper() + "!"
	new_card_image.texture = obtained_card.art
	Game.game.add_card(card_path)
	
	# Removing
	for card in sacrifice_slot.get_card_children():
		Game.game.remove_card(card.card_name)
		card.queue_free()
	
	%wowworm.show()
	%AudioPicked.play()
	GenericTween.squish(%wowworm)
	if Game.game:
		Game.game.lowpass_music(false)
	await get_tree().create_timer(1.5).timeout
	
	await %ConfirmButton.pressed
	player_hand.add_child(obtained_card)
	

func _on_confirm_button_pressed() -> void:
	%wowworm.hide()
	new_card.hide()
	sacrifice_button.show()
	%Hint.show()


func _process(delta: float) -> void:
	var filled_to = sacrifice_slot.get_card_children().size()
	filled = move_toward(filled, filled_to, delta / 0.3)
	%Background.material.set_shader_parameter("filled", filled)
	var mouse_off = (get_local_mouse_position() - Game.SCREEN_SIZE * 0.5)
	%BackBackground.position = mouse_off * 0.01 + Vector2(-30, -20)
	#$Background.position = -mouse_off * 0.02 + Vector2(-30, -20)
	%Foreground.position = -mouse_off * 0.02 + Vector2(-35, -20)
	%Camera2D.position = mouse_off * 0.02 + Game.SCREEN_SIZE * 0.5
	
	%MusicLayer0.volume_db = 0.0 if filled_to > 0 else -80.0
	%MusicLayer1.volume_db = 0.0 if filled_to > 1 else -80.0
	%MusicLayer2.volume_db = 0.0 if filled_to > 2 else -80.0


func _on_button_quit_pressed():
	AudioServer.set_bus_mute(3, false)
