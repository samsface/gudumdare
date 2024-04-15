extends UnitRanged

func _ready() -> void:
	if not is_foe:
		if Game.game.has_upgrade("More Health 1"):
			health += 50
		if Game.game.has_upgrade("More Health 2"):
			health += 50
	super()

func process_movement(delta):
	pass
