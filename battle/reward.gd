extends Control

signal done

var picked := false

func _ready() -> void:
	Game.game.lowpass_music(true)

func _hand_area_child_entered_tree(node: Node) -> void:
	if not node is CardEx:
		return

	%NewCardArea.visible = false
	%LocationName.text = "[jiggle amp=0.4 freq=0.5][center]Great choice![/center][/jiggle]"
	%ArrowInstruction.visible = false
	%AudioPicked.play()
	
	picked = true
	$wowworm/Brush2D.hide()
	$wowworm/Brush2D2.show()
	GenericTween.squish($wowworm)
	Game.game.lowpass_music(false)
	await get_tree().create_timer(2.0).timeout
	
	done.emit()

var t := 0.0
func _process(delta: float) -> void:
	t += delta
	if picked:
		$wowworm.rotation = sin(t * PI * 8.0) * 0.02
	else:
		$wowworm.rotation = sin(t * PI) * 0.05
