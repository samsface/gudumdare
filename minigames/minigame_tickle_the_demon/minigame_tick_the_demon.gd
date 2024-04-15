extends Minigame

var laughs := 0
var counting := true


func _mouse_entered() -> void:
	if laughs == 0:
		$Hm.play()
		$Bird/AnimationPlayer.play("StartLaughing")

func _input(event: InputEvent) -> void:
	if not counting:
		return
		

	if event is InputEventMouseMotion:
		if $AreaBrush2D.mouse_hovering:
			print(laughs)

			laughs +=1 
			
			%Meter.position.y -= 16
			%Meter.position.y = clamp(%Meter.position.y, -14, 1000)
			
			if laughs == 30:
				laugh1()

func laugh1() -> void:
	counting = false
	
	$Bird/AnimationPlayer.play("Laughing")
	
	$Laugh1.play()
	await $Laugh1.finished

	sick()

	counting = true
	
func sick() -> void:
	$Laugh3.play()

	await get_tree().create_timer(0.35).timeout
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property($CanvasLayer/Stuff/Sick, "scale", Vector2.ONE * 3.0, 0.01)
	tween.tween_property($CanvasLayer/Stuff/Sick, "rotation", PI * 0.3, 0.01)

	$Bird/AnimationPlayer.play("Puke")

	counting = true
	
	await get_tree().create_timer(0.4).timeout
	
	_finished()
