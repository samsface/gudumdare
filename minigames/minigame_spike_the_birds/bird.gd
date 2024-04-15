extends Area2D


@export var speed := 500.0

var direction: Vector2 = Vector2.ZERO
var is_dead := false


func spawn(target: Vector2):
	direction = global_position.direction_to(target)
	rotation = direction.angle()


func _physics_process(delta: float) -> void:
	global_position += speed * direction * delta

func play_particles():
	$Outline2.hide()
	$Brush2D.hide()
	$GPUParticles2D.emitting = true
	await $GPUParticles2D.finished
	queue_free()
