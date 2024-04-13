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
	if not sacrifice_button.visible:
		if sacrifice_slot.get_card_children().size() == REQUIRED_SACRIFICE_COUNT:
			sacrifice_button.disabled = false
			sacrifice_button.visible = true
	else:
		if sacrifice_slot.get_card_children().size() < REQUIRED_SACRIFICE_COUNT:
			sacrifice_button.disabled = true
			sacrifice_button.visible = false
			
func _on_sacrifice_button_pressed() -> void:
	#REMOVE CARDS FROM DECK
	
	#GIVE NEW CARD
	#Tier logic
	var lowest_tier = 1
	#Reach into DB to get random new card
	var cards = CardDB.return_cards_by_tier(lowest_tier + 1)
	var random_index = RNG.random_int(0, cards.size() - 1) 
	var new_card_name = cards[random_index]
	
	new_card.show()
	new_card_label.text = "YOU GOT " + new_card_name + "!"

func _on_confirm_button_pressed() -> void:
	new_card.hide()
