@tool
extends Area3D
class_name CardEx

@export var card_name:String = "CARD" :
	set(value):
		card_name = value
		if has_node("%CardNameLabel"):
			%CardNameLabel.text = card_name

@export var art:Texture :
	set(value):
		art = value
		if has_node("%Art"):
			%Art.texture = art
		
@export var spawns:PackedScene
@export var mana_cost := 2
@export var tier := 0
@export var sidelay := false

var dragging := false
var hovered := false
var just_dropped := false
var hover_cooldown:SceneTreeTimer
var spin_tween:Tween

func _mouse_entered() -> void:
	if hover_cooldown and hover_cooldown.time_left > 0.0:
		return

	hovered = true

func _mouse_exited() -> void:
	if dragging:
		return

	hovered = false

func _input_event(camera: Node, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			if not dragging:
				dragging = true
				hovered = true
				set_process_input(true)

func _input(event: InputEvent) -> void:
	if dragging:
		if event is InputEventMouseButton:
			if not event.pressed:
				dragging = false
				hovered = false
				set_process_input(false)
				hover_cooldown = get_tree().create_timer(0.5)
				just_dropped = true
