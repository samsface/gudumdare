extends Area3D

signal card_dropped

@export var sort := false
@export var max_cards := 999999

var invert = true
@export var spread := 0.5

var battle

func get_card_children() -> Array:
	var res := []
	for child in get_children():
		if child is CardEx:
			res.push_back(child)
	
	return res

func _ready() -> void:
	input_ray_pickable = false

func _process(delta) -> void:
	for child in get_card_children():
		if child.just_dropped:
			drop(child)
			continue
	
	for child in get_card_children():
		if child.dragging:
			drag(delta, child)
	
	if sort:
		sort_(delta)

func get_nearest_drop() -> Array:
	var pos = get_viewport().get_mouse_position()
	
	var camera = get_viewport().get_camera_3d()
	var ray_cast = get_viewport().get_camera_3d().get_node("RayCast3D")
	
	ray_cast.target_position = camera.project_ray_origin(pos)
	ray_cast.target_position = camera.global_position + camera.project_ray_normal(pos) * 100

	ray_cast.force_raycast_update()
	
	if ray_cast.is_colliding():
		return [ray_cast.get_collision_point(), ray_cast.get_collider()]
	
	return []

func drag(delta, card) -> void:
	delta *= 10.0
	
	var nearest_drop = get_nearest_drop()
	if not nearest_drop:
		return

	card.global_position = lerp(card.global_position, nearest_drop[0], min(delta * 5.0, 1.0))
	card.global_rotation = lerp(card.global_rotation, nearest_drop[1].global_rotation, min(delta * 5.0, 1.0))

	var drop_area_rotation = nearest_drop[1].global_rotation

	card.global_rotation = lerp(card.global_rotation, drop_area_rotation, min(delta, 1.0, 1.0))


func drop(card: CardEx):
	card.just_dropped = false
	
	var nearest_drop = get_nearest_drop()
	if not nearest_drop:
		return
	
	if nearest_drop[1] == self:
		return
	
	if battle:
		if card.spawn_region == card.SpawnRegion.LEFT and battle.get_global_mouse_position().x > Game.SCREEN_SIZE.x * 0.35:
			return
		if battle.mana < card.mana_cost:
			battle.card_rejected()
			return
	if not nearest_drop[1].can_drop():
		return

	var p = card.global_position
	var r = card.global_rotation
	
	card.get_parent().remove_child(card)
	nearest_drop[1].add_child(card)
	
	print("emitted card_dropped")
	emit_signal("card_dropped") 
	
	card.global_position = p
	card.global_rotation = r
	
	
	if card.spin_tween:
		card.spin_tween.kill()

	card.spin_tween = create_tween()
	card.spin_tween.set_parallel()
	card.spin_tween.tween_property(card, "rotation:y", PI * 2.0, 0.2)
	
	if not card.sidelay:
		card.spin_tween.tween_property(card, "rotation:z", randf_range(-1.0, 1.0) * 0.1, 0.2)
	else:
		card.spin_tween.tween_property(card, "rotation_degrees:z", -90, 0.2)
		
	card.spin_tween.tween_property(card, "position:z", card.position.z + 1.0, 0.1)
	card.spin_tween.tween_property(card, "position:z", card.position.z - 0.01, 0.1).set_delay(0.1)
	card.spin_tween.tween_property(card, "rotation:y", 0.0, 0.0).set_delay(0.2)

func sort_(delta:float) -> void:
	var card_children = get_card_children()
	
	delta *= 10.0

	var total_length := card_children.size() * spread

	var child_count := card_children.size()

	for i in card_children.size():
		var card = card_children[i]

		if card.dragging:
			continue
		
		var x = card.position.x
		var to = i * spread - (total_length * 0.5) + spread * 0.5
		card.position.x = lerp(x, to, min(delta, 1.0))

		var t = -1.0 if invert else 1.0

		var distance_to_origin = x
		
		#get_child(i).position.z = 0

		#print(distance_to_origin)
		#get_child(i).position.y = lerp(get_child(i).position.y, t * abs(distance_to_origin * 0.2), delta)
		#get_child(i).rotation.z = distance_to_origin * 0.2 * t

		if card.spin_tween and card.spin_tween.is_running():
			continue

		if card.hovered:
			card.scale = lerp(card.scale, Vector3.ONE * 1.2, min(delta * 5.0,1.0))
			card.position.y = lerp(card.position.y, 0.1, min(delta,1.0))
			card.position.z = lerp(card.position.z, 0.3, min(delta,1.0))
			inc_recusive(card, "render_priority", 100)
			#get_child(i).position.z = 0.01
		else:
			card.scale = lerp(card.scale, Vector3.ONE, min(delta * 3.0,1.0))
			card.position.y = lerp(card.position.y, 0.0, min(delta,1.0))
			card.position.z = lerp(card.position.z, 0.0, min(delta,1.0))
			card.rotation = lerp(card.rotation, Vector3.ZERO, min(delta,1.0))
			
			inc_recusive(card, "render_priority", i)

# this is because Godot can't fucking render shit that's infront of other shit
func inc_recusive(node, property_name, value):
	if not node:
		return

	var v = node.get(property_name)
	if v is int:
		var o_name = "original_" + property_name
		if not node.has_meta(o_name):
			node.set_meta(o_name, v)
		
		node.set(property_name, node.get_meta(o_name) + value)

	for child in node.get_children():
		inc_recusive(child, property_name, value)

func can_drop() -> bool:
	if get_card_children().size() >= max_cards:
		return false

	return true
