extends Control

signal done

@export var reward_count := 3

var picked := false

func _ready() -> void:
	if Game.game:
		Game.game.lowpass_music(true)
		
	%HandArea.max_cards = reward_count
	
	%LocationName.text = "[jiggle amp=0.4 freq=0.5][center]Pick " + str(reward_count) + " worms![/center][/jiggle]"

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
	await get_tree().create_timer(2.0).timeout
	
	done.emit()

