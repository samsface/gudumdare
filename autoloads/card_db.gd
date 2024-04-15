extends Node

#TO avoid magical strings
const CN_KNIGHT = "res://cards/cards/card_knight.tscn"
const CN_ARCHER = "res://cards/cards/card_archer.tscn"
const CN_RAIN = "res://cards/cards/card_rain.tscn"
const CN_SHOTGUN = "res://cards/cards/card_shotgun.tscn"
const CN_PROTECTOR = "res://cards/cards/card_protector.tscn"
const CN_BUFF = "res://cards/cards/card_buff.tscn"

const CARD_PATHS = [
	CN_KNIGHT,
	CN_ARCHER,
	CN_RAIN,
	CN_PROTECTOR,
	CN_SHOTGUN,
	CN_BUFF,
]

var cards = {} #Key: Card Name, contains instiatated card object
#Eg: { "Archer": StaticBody3D:<Area3D#37832623368> }

func _ready() -> void:
	for path in CARD_PATHS:
		var card = load(path).instantiate()
		
		cards[path] = card

func return_cards_by_tier(tier: int) -> Array:
	var array: Array
	for card in cards:
		if cards[card].tier == tier:
			array.append(card)
	return array
