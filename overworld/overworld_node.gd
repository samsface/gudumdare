@tool
class_name OverworldNode extends Node2D

@export var neighbors: Array[Node2D] = []

@export var available := false

@export var is_altar := false
@export var is_shop := false

enum Type{BATTLE, BATTLE_PATH, MINI_1, MINI_2, MINI_3}

var completed := false

var color_normal = Color.LIGHT_GOLDENROD
var color_hover = Color.ORANGE

var hovering := false
var t := 0.0

var my_name: String
@export var click_range := 40.0

func _ready() -> void:
	if Engine.is_editor_hint():
		for neighbor in neighbors:
			if not neighbor.neighbors.has(self):
				neighbor.neighbors.push_back(self)
	%Name.text = name.capitalize()
	my_name = name
	
	if is_shop or is_altar:
		color_normal = Color.WHITE
	
	if not available:
		%Sprite.modulate = Color("466856")
	
	var conquered = Game.game.conquered_nodes.has(name)
	if conquered:
		$Flag.visible = true

func pop_flag():
	$Flag.visible = false
	await get_tree().create_timer(1.0).timeout
	
	for i in 10:
		var worm_pickup = load("res://battle/pickup_worm.tscn").instantiate()
		get_parent().add_child(worm_pickup)
		worm_pickup.global_position = global_position
		worm_pickup.velocity = Vector2.from_angle(randf() * TAU) * randf_range(0.2, 1.0) * 800.0
	
	$AudioWin.play()
	$Flag.visible = true
	GenericTween.squish($Flag)

func _process(delta: float) -> void:
	#if not Engine.is_editor_hint() and Input.is_key_pressed(KEY_P):
		#unlock()
	t += delta
	
	if not available:
		return
	
	#if Engine.is_editor_hint():
	queue_redraw()
	if hovering:
		%Sprite.modulate = color_hover if fmod(t / 0.1, 1.0) < 0.5 else color_normal
	else:
		%Sprite.modulate = color_normal
	
	

	if not hovering and get_local_mouse_position().length() < click_range:
		get_parent().set_title(name.capitalize())
		hovering = true
		$AudioHover.play()
		get_parent().hovering = true


	if hovering and get_local_mouse_position().length() > click_range + 20.0:
		get_parent().set_title()
		hovering = false
		get_parent().hovering = false


func _draw() -> void:
	for neighbor in neighbors:
		var width := 25.0
		var color = Color.WHITE
		if not neighbor.available or not available:
			color = Color.DIM_GRAY
			color.a *= 0.5
			width = 15.0
		draw_line(Vector2.ZERO, (neighbor.position - position) * 0.5 / 0.7, color, width)


func _on_area_brush_2d_mouse_clicked() -> void:
	if not available:
		return
	
	Game.game.transition.set_circle_position(global_position)
	$AudioEnter.play()
	if is_shop:
		Game.game.open_shop()
		return
	if is_altar:
		Game.game.open_altar()
		return
	Game.game.open_battle("res://battle/battles/%s.tscn" % name.to_snake_case(), name)
	get_parent().entering = true
	
func unlock(play_animation := false):
	available = true

	if play_animation:
		%AnimationPlayer.play("unlock") 
