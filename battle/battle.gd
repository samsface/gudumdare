class_name Battle
extends Node2D

var deck := []
var hand := []

var units := []
var friends := []
var foes := []

var card_add_delay := 0.0

var dragging_card: Card


@onready var tower_player = %TowerPlayer
@onready var tower_enemy = %TowerEnemy

var mana := 0.0
var max_mana := 10
var mana_regen_per_sec := 1.0

func _ready() -> void:
	var card_knight = load("res://battle/cards/card_knight.tscn")
	add_card(card_knight.instantiate())
	add_card(card_knight.instantiate())
	add_card(card_knight.instantiate())
	add_card(card_knight.instantiate())
	
	tower_player.battle = self
	tower_enemy.battle = self
	friends.push_back(tower_player)
	foes.push_back(tower_enemy)
	
	%Mana.max_value = max_mana


func add_card(card):
	card.init(self)
	deck.push_back(card)
	%Deck.add_child(card)


func _process(delta: float) -> void:
	process_add_to_hand(delta)
	mana = move_toward(mana, max_mana, delta * mana_regen_per_sec)
	%Mana.value = mana

func _physics_process(delta: float) -> void:
	for i in units.size():
		for j in range(i + 1, units.size()):
			var unit_a: Unit = units[i]
			var unit_b: Unit = units[j]
			var radius = unit_a.radius + unit_b.radius
			var distance = unit_a.position.distance_squared_to(unit_b.position)
			if distance < radius * radius:
				distance = sqrt(distance)
				var push = radius - distance
				var ratio = unit_a.weight / unit_b.weight
				var direction = unit_a.position.direction_to(unit_b.position)
				unit_a.position -= direction * push * ratio
				unit_b.position += direction * push * (1.0 - ratio)

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

func add_unit(unit: Unit, position: Vector2):
	%Fight.add_child(unit)
	unit.battle = self
	unit.position = position
	if unit.is_foe:
		foes.push_back(unit)
	else:
		friends.push_back(unit)
	units.push_back(unit)
