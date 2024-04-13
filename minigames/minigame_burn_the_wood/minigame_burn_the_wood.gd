extends Minigame


var stick_count := 0
var selected_stick: Stick = null

@onready var flames = [
	$Fire/FlameStart,
	$Fire/FlameSmall,
	$Fire/FlameMedium,
	$Fire/FlameLarge
]


func _ready() -> void:
	super()

	var spawns = $SpawnPoints.get_children()
	spawns.shuffle()
	var sticks = $StickSpawner.spawn(spawns)

	for stick: Stick in sticks:
		stick.stick_selected.connect(handle_stick_selected)

	hide_flames()
	$Fire/FlameStart.show()



func _physics_process(delta: float) -> void:
	if selected_stick != null:
		selected_stick.position = get_global_mouse_position()


func handle_stick_selected(stick: Stick):
	if selected_stick == null:
		selected_stick = stick
	elif selected_stick == stick:
		selected_stick = null


func hide_flames():
	for f in flames:
		f.hide()


func _on_fire_area_entered(area: Area2D) -> void:
	selected_stick.queue_free()
	selected_stick = null

	stick_count += 1

	hide_flames()
	match stick_count:
		8, 9, 10:
			$Fire/FlameLarge.show()
		5, 6, 7:
			$Fire/FlameMedium.show()
		2, 3, 4:
			$Fire/FlameSmall.show()
		0, 1:
			$Fire/FlameStart.show()
