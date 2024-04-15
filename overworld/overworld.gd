extends Node2D

var cam_to := Vector2.ZERO
var cam_angle_to := 0.0

var title_visible := false

var entering := false

var mouse_off: Vector2

var hovering := false

var current_battle_node: Node2D

func _ready() -> void:
	Game.game.play_music_overworld()
	Game.game.duck_music(false)
	%Camera2D.zoom = Vector2.ONE * 3.3
	
	#Check if battle was won and unlock new nodes
	var just_unlocked_nodes: Array = []
	if Game.game.battle_won:
		Game.game.battle_won = false
		
		var conquered_node: OverworldNode = get_node(Game.game.current_battle_node_name)
		Game.game.conquered_nodes.append(conquered_node)
		for neighbor in conquered_node.neighbors:
			if not neighbor.available:
				Game.game.unlocked_nodes.append(neighbor.my_name)
				just_unlocked_nodes.append(neighbor.my_name)
	
	for node_name in Game.game.unlocked_nodes:
		var node: OverworldNode = get_node(node_name)
		if not just_unlocked_nodes.has(node_name):
			node.unlock()
			
	for node_name in just_unlocked_nodes:
		var node: OverworldNode = get_node(node_name)
		node.unlock(true)
		await get_tree().create_timer(0.5).timeout

func _on_button_button_down() -> void:
	Game.game.open_shop()

func _process(delta: float) -> void:
	if entering:
		%Title.visible = false
		%Camera2D.zoom += Vector2.ONE * delta
		%Camera2D.position += mouse_off * delta * 0.5
	else:
		var zoom_to = 1.15 if hovering else 1.1
		%Camera2D.zoom = %Camera2D.zoom.lerp(Vector2.ONE * zoom_to, delta * 10.0)
		mouse_off = (get_local_mouse_position() - Game.SCREEN_SIZE * 0.5) * (1.0 + (zoom_to - 1.0) * 8.0)
		cam_to = mouse_off * 0.08 + Game.SCREEN_SIZE * 0.5
		cam_angle_to = mouse_off.x * 0.00005
		%Camera2D.position = lerp(%Camera2D.position, cam_to, delta * 10.0)
		%Camera2D.rotation = lerp(%Camera2D.rotation, cam_angle_to, delta * 5.0)
		%Clouds.position = -(%Camera2D.position - Game.SCREEN_SIZE * 0.5) * 0.3
		
		%Title.scale.y = move_toward(%Title.scale.y, 1.0 if title_visible else 0.0, delta / 0.05)

func set_title(value := ""):
	if value == "":
		title_visible = false
	else:
		title_visible = true
		%LocationName.text = "[jiggle amp=0.4 freq=0.5][center]%s[/center][/jiggle]" % value.to_upper()
