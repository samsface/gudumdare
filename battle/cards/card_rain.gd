extends Card

func summon():
	for unit: Unit in battle.friends:
		unit.boost_speed(1.5, 5.0)
		unit.boost_reload(1.2, 5.0)
