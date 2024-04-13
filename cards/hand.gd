extends Node3D

@export var spread := 0.6

var invert = true

@onready var camera = $"../Camera3D"
@onready var ray_cast = $"../Camera3D/RayCast3D"

func _process(delta) -> void:
	sort_(delta)

func get_nearest_drop() -> Array:
	var pos = get_viewport().get_mouse_position()
	
	ray_cast.target_position = camera.project_ray_origin(pos)
	print(camera.project_ray_normal(pos))
	ray_cast.target_position = camera.global_position + camera.project_ray_normal(pos) * 100

	ray_cast.force_raycast_update()
	
	if ray_cast.is_colliding():
		return [ray_cast.get_collision_point(), ray_cast.get_collider()]
	
	return []

func drag(delta, card) -> void:
	var nearest_drop = get_nearest_drop()
	if not nearest_drop:
		return

	card.global_position = lerp(card.global_position, nearest_drop[0], delta)
	card.global_rotation = lerp(card.global_rotation, nearest_drop[1].global_rotation, delta)

func drop(card):
	var nearest_drop = get_nearest_drop()
	if not nearest_drop:
		return
	
	card.just_dropped = false
	
	var p = card.global_position
	var r = card.global_rotation
	
	card.get_parent().remove_child(card)
	nearest_drop[1].add_child(card)
	
	card.global_position = p
	card.global_rotation = r
	
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(card, "rotation:y", PI * 2.0, 0.2)
	tween.tween_property(card, "rotation:z", randf_range(-1.0, 1.0) * 0.1, 0.2)
	tween.tween_property(card, "position:z", card.position.z + 1.0, 0.1)
	tween.tween_property(card, "position:z", card.position.z, 0.1).set_delay(0.1)
	

func sort_(delta:float) -> void:
	delta *= 10.0

	var total_length := 0.0
	for child in get_children():
		total_length += spread

	for child in get_children():
		if child.just_dropped:
			drop(child)
			continue

	var child_count := get_child_count()

	for i in child_count:
		if get_child(i).dragging:
			drag(delta, get_child(i))
			continue
		
		var x = get_child(i).position.x
		var to = i * spread - (total_length * 0.5) + spread * 0.5
		get_child(i).position.x = lerp(x, to, delta)

		var t = -1.0 if invert else 1.0

		var distance_to_origin = x
		
		#get_child(i).position.z = 0

		#print(distance_to_origin)
		#get_child(i).position.y = lerp(get_child(i).position.y, t * abs(distance_to_origin * 0.2), delta)
		#get_child(i).rotation.z = distance_to_origin * 0.2 * t

		if get_child(i).hovered:
			get_child(i).scale = lerp(get_child(i).scale, Vector3.ONE * 1.1, delta)
			#get_child(i).position.z = 0.01
		else:
			get_child(i).scale = lerp(get_child(i).scale, Vector3.ONE, delta)
			get_child(i).position.y = lerp(get_child(i).position.y, 0.0, delta)
			get_child(i).position.z = lerp(get_child(i).position.z, 0.0, delta)
			get_child(i).rotation = lerp(get_child(i).rotation, Vector3.ZERO, delta)
