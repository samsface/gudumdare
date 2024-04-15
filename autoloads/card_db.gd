extends Node

#TO avoid magical strings
const CN_KNIGHT = "res://cards/cards/card_knight.tscn"
const CN_ARCHER = "res://cards/cards/card_archer.tscn"
const CN_RAIN = "res://cards/cards/card_rain.tscn"
const CN_SHOTGUN = "res://cards/cards/card_shotgun.tscn"
const CN_PROTECTOR = "res://cards/cards/card_protector.tscn"
const CN_BUFF = "res://cards/cards/card_buff.tscn"
const CN_DRAGON = "res://cards/cards/card_dragon.tscn"
const CN_KNIGHT2 = "res://cards/cards/card_knight2.tscn"
const CN_WIZARD = "res://cards/cards/card_wizard.tscn"
const CN_ROBOT = "res://cards/cards/card_robot.tscn"
const CN_LASER = "res://cards/cards/card_laser.tscn"
const CN_ARM = "res://cards/cards/card_arm.tscn"
const CN_KFC = "res://cards/cards/card_kfc.tscn"
const CN_TICKLE = "res://cards/cards/card_tickle.tscn"

const CARD_PATHS = [
	CN_KNIGHT,
	CN_ARCHER,
	CN_RAIN,
	CN_PROTECTOR,
	CN_SHOTGUN,
	CN_BUFF,
	CN_DRAGON,
	CN_KNIGHT2,
	CN_WIZARD,
	CN_ROBOT,
	CN_LASER,
	CN_ARM,
	CN_KFC,
	CN_TICKLE,
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
