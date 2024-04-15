extends Node2D

var step := -1

@onready var b1 = $Bird1
@onready var b2 = $Bird2

func _ready() -> void:
	do_step()

func do_step():
	step_wait = 0.5
	match step:
		-1:
			b1.set_frame(0)
			b2.set_frame(0)
		0:
			focus(1)
			speak("oh birdy, i love u so much", 1)
			%AudioChirp1.play()
		1:
			focus(2)
			speak("same uwu", 2)
			%AudioChirp2.play()
			GenericTween.squish(b2)
		2:
			focus(1)
			b1.set_frame(1)
			speak("would u still love me..", 1)
			%AudioChirp1.play()
			GenericTween.squish(b1)
		3:
			speak("if i was a worm", 1)
			%AudioChirp1.play()
			GenericTween.squish(b1)
		4:
			focus(2)
			b2.set_frame(1)
			speak("of course hi hi", 2)
			%AudioChirp2.play()
			GenericTween.squish(b2)
		5:
			%Music.stop()
			focus(1)
			speak("im so glad because i have to show u something", 1)
			%AudioChirp1.play()
			b1.set_frame(2)
		6:
			speak("...", 1)
			b2.visible = false
			b1.position = Vector2(600, 816)
			b1.set_frame(3)
		7:
			b2.visible = true
			focus(2)
			speak("eww gross wtf", 1)
			%AudioChirp2.play()
			%AudioWings.play(0.1)
			b1.set_frame(4)
			b2.set_frame(2)
			#GenericTween.squish(b2)
		8:
			focus(1)
			b2.visible = false
			speak("grrr", 1)
			b1.set_frame(5)
			GenericTween.squish(b2)
		9:
			var tween = create_tween()
			tween.tween_property($ColorRect, "color", Color.RED, 0.5)
			
			speak("i will murder every bird", 1)
			%AudioChirp1.play()
		10:
			Game.game.open_overworld()
	
	step += 1

func speak(text, char):
	var label: Label
	if char == 1:
		label = %Text1
		%Text1.visible = true
		%Text2.visible = false
	else:
		label = %Text2
		%Text2.visible = true
		%Text1.visible = false
	label.text = text

func focus(value):
	var tween1 = create_tween().set_parallel()
	var to_1 = Vector2(454, 816) if value == 1 else Vector2(354, 816)
	var c1 = Color.WHITE if value == 1 else Color.DIM_GRAY
	var s1 = Vector2.ONE if value == 1 else Vector2.ONE * 0.8
	tween1.tween_property(b1, "position", to_1, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween1.tween_property(b1, "modulate", c1, 0.3).set_trans(Tween.TRANS_LINEAR)
	if value == 2:
		tween1.tween_property(b1, "scale", s1, 0.3)
	
	var tween2 = create_tween().set_parallel()
	var c2 = Color.WHITE if value == 2 else Color.DIM_GRAY
	var to_2 = Vector2(1191, 742) if value == 2 else Vector2(1391, 742)
	var s2 = Vector2.ONE if value == 2 else Vector2.ONE * 0.8
	tween2.tween_property(b2, "position", to_2, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween2.tween_property(b2, "modulate", c2, 0.3).set_trans(Tween.TRANS_LINEAR)
	if value == 1:
		tween2.tween_property(b2, "scale", s2, 0.3)

var step_wait := 0.0

func _process(delta):
	if step_wait > 0:
		step_wait -= delta
	elif Input.is_action_just_pressed("LMB"):
		do_step()
