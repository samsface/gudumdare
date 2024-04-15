extends Node2D

var is_dead = false

func die():
	$AnimationPlayer.play("die")
	is_dead = true
	Game.give_worm(global_position)

func _on_animation_player_animation_finished(anim_name):
	queue_free()
