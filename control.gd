extends Control

var names = [
	"Martin Firbacher",
	"Guy",
	"LucyLavend",
	"Sam",
	"TheWizardToucan",
	"jmbiv",
]

func _ready() -> void:
	names.shuffle()
	for i in names.size():
		%Wheel.get_child(i).text = names[i]
	Game.game.duck_music()

var t := 0.0
func _process(delta: float) -> void:
	t += delta
	for i in %Wheel.get_children().size():
		var label = %Wheel.get_child(i)
		label.position = Vector2.from_angle(i / float(%Wheel.get_children().size()) * TAU + t * 0.2) * Vector2(280.0, 120.0)
	%Scroll.position.y -= delta * 40.0
