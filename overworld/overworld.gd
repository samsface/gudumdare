extends Node2D

var cam_to := Vector2.ZERO
var cam_angle_to := 0.0

var title_visible := false

var entering := false

var mouse_off: Vector2

func _ready() -> void:
	pass

func _on_button_button_down() -> void:
	Game.game.open_shop()

func _process(delta: float) -> void:
	if entering:
		%Title.visible = false
		$Camera2D.zoom += Vector2.ONE * delta
		$Camera2D.position += mouse_off * delta * 0.5
	else:
		mouse_off = (get_local_mouse_position() - Game.SCREEN_SIZE * 0.5)
		cam_to = mouse_off * 0.1 + Game.SCREEN_SIZE * 0.5
		cam_angle_to = mouse_off.x * 0.00005
		$Camera2D.position = lerp($Camera2D.position, cam_to, delta * 10.0)
		$Camera2D.rotation = lerp($Camera2D.rotation, cam_angle_to, delta * 5.0)
		$Clouds.position = -($Camera2D.position - Game.SCREEN_SIZE * 0.5) * 0.3
		
		%Title.scale.y = move_toward(%Title.scale.y, 1.0 if title_visible else 0.0, delta / 0.05)

func set_title(value := ""):
	if value == "":
		title_visible = false
	else:
		title_visible = true
		%LocationName.text = "[jiggle amp=0.4 freq=0.5][center]%s[/center][/jiggle]" % value.to_upper()
