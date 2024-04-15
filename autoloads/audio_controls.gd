extends CanvasLayer

const BUS_SOUND = 1
const BUS_MUSIC = 2

@onready var button := $Button
@onready var controls := $Controls 
@onready var sound_slider := $Controls/SoundSlider
@onready var music_slider := $Controls/MusicSlider

func _ready() -> void:
	controls.hide()

func _on_button_pressed():
	controls.visible = !controls.visible

func _on_sound_slider_value_changed(value):
	AudioServer.set_bus_volume_db(BUS_SOUND, linear_to_db(value))

func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(BUS_MUSIC, linear_to_db(value))

func _set_overworld_position():
	button.global_position = Vector2(7, 750)
	controls.global_position = Vector2(0, 0)
	
func _set_battle_position():
	button.global_position = Vector2(7, 718)
	controls.global_position = Vector2(0, -32)
