extends Minigame

var laughs := 0
var counting := true

func _on_win_mouse_pressed() -> void:
	win()


func _on_loose_mouse_pressed() -> void:
	loose()


func _mouse_entered() -> void:
	if laughs == 0:
		GenericTween.squish($Hm2)
		$Hm.play()
		$Idle.visible = false
		$Hm2.visible = true

func _input(event: InputEvent) -> void:
	if not counting:
		return
		

	if event is InputEventMouseMotion:
		if $AreaBrush2D.mouse_hovering:
			print(laughs)

			laughs +=1 
			
			%Meter.position.y -= 4
			%Meter.position.y = clamp(%Meter.position.y, -14, 1000)
			
			if laughs == 30:
				laugh1()
			
			if laughs == 60:
				laugh2()
				
			if laughs == 90:
				laugh3()

func laugh1() -> void:
	GenericTween.shake($Laugh)
	
	counting = false
	
	$Idle.visible = false
	$Hm2.visible = false
	$Laugh.visible = true
	
	$Laugh1.play()
	await $Laugh1.finished
	$Hm2.visible = true
	$Laugh.visible = false
	
	$Hm.play()
	GenericTween.squish($Hm2)
	await $Hm.finished
	
	counting = true
	
func laugh2() -> void:
	GenericTween.shake($Laugh)
	
	counting = false
	
	$Idle.visible = false
	$Hm2.visible = false
	$Laugh.visible = true
	
	$Laugh2.play()
	await $Laugh2.finished
	$Hm2.visible = true
	$Laugh.visible = false
	
	$Hm.play()
	GenericTween.squish($Hm2)
	await $Hm.finished
	
	counting = true
	
func laugh3() -> void:
	GenericTween.shake($Laugh)
	
	counting = false
	
	$Idle.visible = false
	$Hm2.visible = false
	$Laugh.visible = true
	
	$Laugh3.play()
	

	await get_tree().create_timer(0.25).timeout
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property($Sick, "scale", Vector2.ONE * 3.0, 0.01)
	tween.tween_property($Sick, "rotation", PI * 0.3, 0.01)

	$Sick.visible = true
	$Laugh.visible = false

	counting = true
	
	await get_tree().create_timer(0.4).timeout
	
	win()
