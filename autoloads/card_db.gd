extends Node

const CARD_PATHS = [
	"res://cards/cards/archer.tscn",
	"res://cards/cards/knight.tscn"
]

var cards = {}

func _ready() -> void:
	for path in CARD_PATHS:
		print(path)
		var card = load(path).instantiate()

		cards[card.card_name] = card
		print(str(cards))

func return_cards_by_tier(tier):
	var array: Array
	for card in cards:
		if cards[card].tier == tier:
			array.append(card)
			
	return array