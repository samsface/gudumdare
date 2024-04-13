extends Node2D


func _ready() -> void:
	%CompleteScreen.visible = false


func complete(rating: float):
	%CompleteScreen.visible = true
