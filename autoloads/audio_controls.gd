extends CanvasLayer

const BUS_SOUND = 4
const BUS_MUSIC = 3

@onready var arrow := $Button/Arrow
@onready var controls := $Controls 
@onready var sound_slider := $Controls/SoundSlider
@onready var music_slider := $Controls/MusicSlider

func _ready() -> void:
	_rotate_arrow()
	controls.show()
	
func _rotate_arrow() -> void:
	match controls.visible:
		true: arrow.rotation_degrees = 0
		false: arrow.rotation_degrees = 180

func _on_button_pressed():
	controls.visible = !controls.visible
	_rotate_arrow()

func _on_sound_slider_value_changed(value):
	AudioServer.set_bus_volume_db(BUS_SOUND, linear_to_db(value))

func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(BUS_MUSIC, linear_to_db(value))
