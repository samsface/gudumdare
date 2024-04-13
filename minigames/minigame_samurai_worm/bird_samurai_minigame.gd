extends Node2D

var is_dead = false

func die():
	$AnimationPlayer.play("die")
	is_dead = true

func _on_animation_player_animation_finished(anim_name):
	queue_free()
