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
@export var mana_cost:int :
	set(value):
		mana_cost = value
		if has_node("%ManaCost"):
			%ManaCost.text = str(mana_cost)
@export var tier := 0
@export var sidelay := false

enum SpawnRegion {LEFT, ANYWHERE}
@export var spawn_region = SpawnRegion.LEFT

var dragging := false
var hovered := false
var just_dropped := false
var hover_cooldown:SceneTreeTimer
var spin_tween:Tween

var color: Color

func _mouse_entered() -> void:
	if hover_cooldown and hover_cooldown.time_left > 0.0:
		return
	%AudioHover.play()
	hovered = true

func _mouse_exited() -> void:
	if dragging:
		return

	hovered = false

func _ready() -> void:
	color = [Color.YELLOW, Color.DODGER_BLUE, Color.TOMATO][tier-1]
	%Card.mesh.material.set_shader_parameter("modulate", color)
	%Card.mesh.material.set_shader_parameter("rand", randf())
	%TierLabel.modulate = color * 0.5
	%TierLabel.text = ["GRUB", "STRONG", "BEAST"][tier-1]

func _input_event(camera: Node, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			if not dragging:
				dragging = true
				Game.dragging_card = self
				%AudioDrag.play()
				hovered = true
				set_process_input(true)

func _input(event: InputEvent) -> void:
	if dragging:
		if event is InputEventMouseButton:
			if not event.pressed:
				dragging = false
				Game.dragging_card = null
				hovered = false
				set_process_input(false)
				hover_cooldown = get_tree().create_timer(0.5)
				just_dropped = true

func _process(delta: float) -> void:
	if is_instance_valid(Game.battle):
		%Card.mesh.material.set_shader_parameter("mana", Game.battle.mana / mana_cost)
	else:
		%Card.mesh.material.set_shader_parameter("mana", 1.0)
