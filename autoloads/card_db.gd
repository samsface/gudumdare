extends Node

const CARD_PATHS = [
	"res://cards/cards/archer.tscn",
	"res://cards/cards/knight.tscn",
	"res://cards/cards/rain.tscn",
]

var cards = {}

func _ready() -> void:
	for path in CARD_PATHS:
		print(path)
		var card = load(path).instantiate()

		cards[card.card_name] = card
		print(str(cards))

func return_card_scene(card_name: String) -> Node3D:
	return cards[card_name]

func return_card_texture(card_name: String) -> Texture:
	return cards[card_name].art

func return_cards_by_tier(tier: int) -> Array:
	var array: Array
	for card in cards:
		if cards[card].tier == tier:
			array.append(card)
			
	return array
