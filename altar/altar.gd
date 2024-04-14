extends Control

const REQUIRED_SACRIFICE_COUNT = 3

@onready var player_hand = $SubViewportContainer/SubViewport/HandTest/PlayerHand
@onready var sacrifice_button := $TopPlayer/SacrificeButton
@onready var new_card := $TopPlayer/NewCard
@onready var new_card_label := $TopPlayer/NewCard/Label
@onready var sacrifice_slot := $SubViewportContainer/SubViewport/HandTest/SacrificeSlot

var filled := 0.0

func _ready() -> void:
	#Signals
	sacrifice_slot.card_dropped.connect(_check_sacrifice_button)
	player_hand.card_dropped.connect(_check_sacrifice_button)
	#Hide stuff
	new_card.hide()
	#Funcs
	_check_sacrifice_button()
	
func _check_sacrifice_button():
	print(str(sacrifice_slot.get_card_children().size()))
	
	if sacrifice_slot.get_card_children().size() == REQUIRED_SACRIFICE_COUNT:
		sacrifice_button.disabled = false
	else:
		sacrifice_button.disabled = true
			
func _on_sacrifice_button_pressed() -> void:
	#REMOVE CARDS FROM DECK
	
	#GET NEW CARD
	var lowest_tier = 666 #Should replace with actual highest tier :-)
	for card in sacrifice_slot.get_card_children():
		if card.tier < lowest_tier:
			lowest_tier = card.tier
	print("lowest tier is now " + str(lowest_tier))
	
	var cards = CardDB.return_cards_by_tier(lowest_tier)
	var random_index = RNG.random_int(0, cards.size() - 1) 
	var new_card_name = cards[random_index]
	
	new_card.show()
	sacrifice_button.hide()
	new_card_label.text = "YOU GOT " + new_card_name + "!"
	#Delete cards from scene TODO delete from player too
	for card in sacrifice_slot.get_card_children():
		card.queue_free()

func _on_confirm_button_pressed() -> void:
	
	
	new_card.hide()
	sacrifice_button.show()


func _process(delta: float) -> void:
	var filled_to = sacrifice_slot.get_card_children().size()
	filled = move_toward(filled, filled_to, delta / 0.3)
	$Background.material.set_shader_parameter("filled", filled)
	var mouse_off = (get_local_mouse_position() - Game.SCREEN_SIZE * 0.5)
	$BackBackground.position = mouse_off * 0.01 + Vector2(-30, -20)
	#$Background.position = -mouse_off * 0.02 + Vector2(-30, -20)
	$Foreground.position = -mouse_off * 0.02 + Vector2(-35, -20)
	$Camera2D.position = mouse_off * 0.02 + Game.SCREEN_SIZE * 0.5
