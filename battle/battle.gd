class_name Battle
extends Node2D

const CARD = preload("res://battle/card.tscn")

var deck := []
var hand := []

var friends := []
var foes := []

var card_add_delay := 0.0

var dragging_card: Card

func _ready() -> void:
	create_card(CardData.new())
	create_card(CardData.new())
	create_card(CardData.new())
	create_card(CardData.new())


func create_card(data):
	var card = CARD.instantiate()
	card.init(data, self)
	deck.push_back(card)
	%Deck.add_child(card)


func _process(delta: float) -> void:
	process_add_to_hand(delta)

func process_add_to_hand(delta):
	if deck.size() <= 0:
		return
	
	if card_add_delay > 0.0:
		card_add_delay -= delta
		return
	
	var hand_size := 3
	if hand.size() < hand_size:
		take_card()
		card_add_delay = 0.1


func take_card():
	if deck.size() > 0:
		var card: Card = deck.pick_random()
		deck.erase(card)
		hand.push_back(card)
		card.visible = true


func put_card(card):
	hand.erase(card)
	deck.push_back(card)
	card.visible = false
	card_add_delay = 0.1

func get_card_position(card):
	if not hand.has(card):
		return Vector2(0, 200.0)
	var padding := 200.0
	return Vector2((hand.find(card) - (hand.size() - 1) * 0.5) * padding, 0)
