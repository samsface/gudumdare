extends Control

signal done

const CARDS_TO_OFFER = 5

@export var reward_count := 2

var picked := false

func _ready() -> void:
	if Game.game:
		Game.game.lowpass_music(true)
		
	%HandArea.max_cards = reward_count
	%LocationName.text = "[jiggle amp=0.4 freq=0.5][center]Pick " + str(reward_count) + " worms![/center][/jiggle]"

	var cards = []
	#RNG for tier 3
	if RNG.random_int(1,100) >= 95:
		cards.append(CardDB.return_cards_by_tier(3).pick_random())
	#RNG for tier 2
	if RNG.random_int(1,100) >= 80:
		cards.append(CardDB.return_cards_by_tier(2).pick_random())
		
	#FILL the rest of tiers with 1, take higher tears into account
	var tier_1_cards = CardDB.return_cards_by_tier(1)
	
	for i in CARDS_TO_OFFER - cards.size():
		tier_1_cards.shuffle()
		cards.append(tier_1_cards[0])
		
	cards.shuffle() #Shuffle cards we gonna offer
	print("CARDS TO OFFER ARE:\n" + str(cards))
	
	for card in cards:
		if card == null: #Crash prevent since we dont have tier 2/3 cards yet
			return
		
		var new_card: Node3D = CardDB.return_card_scene(card).duplicate()
		%NewCardArea.add_child(new_card) 

func _hand_area_child_entered_tree(node: Node) -> void:
	if %HandArea.get_card_children().size() == reward_count:
		$Confirm.visible = true

func _hand_area_child_exiting_tree(node: Node) -> void:
	$Confirm.visible = false

var t := 0.0
func _process(delta: float) -> void:
	t += delta
	if picked:
		$wowworm.rotation = sin(t * PI * 8.0) * 0.02
	else:
		$wowworm.rotation = sin(t * PI) * 0.05


func _confirm_pressed() -> void:
	$Confirm.visible = false
	var tween = create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_CIRC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(%HandArea, "position:y", 0.0, 0.2)
	tween.tween_property(%HandArea, "position:z", 0.5, 0.2)

	%NewCardArea.visible = false
	%LocationName.text = "[jiggle amp=0.4 freq=0.5][center]Great choice![/center][/jiggle]"
	%ArrowInstruction.visible = false
	%AudioPicked.play()
	
	picked = true
	$wowworm/Brush2D.hide()
	$wowworm/Brush2D2.show()
	GenericTween.squish($wowworm)
	if Game.game:
		Game.game.lowpass_music(false)
	await get_tree().create_timer(1.5).timeout
	
	done.emit()

