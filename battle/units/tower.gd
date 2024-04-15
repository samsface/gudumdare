extends UnitRanged

@export var shooting := true

func _ready() -> void:
	if not is_foe:
		if Game.game.has_upgrade("More Health 1"):
			health += 100
		if Game.game.has_upgrade("More Health 2"):
			health += 200
		shooting = Game.game.has_upgrade("Tower Shoots")
	super()

func process_movement(delta):
	if shooting:
		super.process_movement(delta)
