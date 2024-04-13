extends Control

const REQUIRED_SACRIFICE_COUNT = 3

@onready var player_hand = $SubViewportContainer/SubViewport/HandTest/PlayerHand
@onready var sacrifice_button := $CanvasLayer/SacrificeButton
@onready var new_card := $CanvasLayer/NewCard
@onready var new_card_label := $CanvasLayer/NewCard/Label
@onready var sacrifice_slot := $SubViewportContainer/SubViewport/HandTest/SacrificeSlot

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
	new_card_label.text = "YOU GOT " + new_card_name + "!"

func _on_confirm_button_pressed() -> void:
	new_card.hide()
