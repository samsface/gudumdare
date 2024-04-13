extends Control

const REQUIRED_SACRIFICE_COUNT = 3

@onready var sacrifice_slots := [
	$SacrificeSlot1,
	$SacrificeSlot2,
	$SacrificeSlot3,
]

@onready var sacrifice_button := $SacrificeButton
@onready var new_card := $NewCard
@onready var new_card_label := $NewCard/Label

var cards_to_sacrifice := []

func _ready() -> void:
	#sacrifice_button.hide()
	#sacrifice_button.disabled = true
	new_card.hide()
	return

func _can_add_sacrifice() -> bool:
	return cards_to_sacrifice.size() < REQUIRED_SACRIFICE_COUNT

func _can_sacrifice() -> bool:
	return cards_to_sacrifice.size() == REQUIRED_SACRIFICE_COUNT

func add_sacrifice() -> void:
	
	if _can_sacrifice():
		sacrifice_button.show()
		sacrifice_button.disabled = false

func _on_sacrifice_button_pressed():
	#REMOVE CARDS FROM DECK
	
	#GIVE NEW CARD
	#Tier logic
	var lowest_tier = 1
	var highest_tier = 2
	
	#SHOW IT
	var card_name = "KNIGHT"
	new_card.show()
	new_card_label.text = "YOU GOT " + card_name + "!"

func _on_confirm_button_pressed():
	new_card.hide()
