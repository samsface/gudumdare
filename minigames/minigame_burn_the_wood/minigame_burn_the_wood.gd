extends Minigame


@export var number_of_sticks := 20

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
	var sticks = $StickSpawner.spawn(number_of_sticks, spawns)

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

	# No true "lose" condition, at least right now
	if stick_count >= number_of_sticks:
		$CanvasLayer/Instructions.hide()
		win(1.0)
		return

	hide_flames()

	var stick_percentage: float = stick_count as float / number_of_sticks as float
	print(stick_percentage)
	if stick_percentage >= 0.8:
		$Fire/FlameLarge.show()
	elif stick_percentage >= 0.5:
		$Fire/FlameMedium.show()
	elif stick_percentage >= 0.25:
		$Fire/FlameSmall.show()
	else:
		$Fire/FlameStart.show()
