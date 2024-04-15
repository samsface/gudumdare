extends Button

@export var upgrade := ""
@export var cost := 0

func _ready() -> void:
	if Game.game.upgrades.has(upgrade):
		set_bought()
	text = upgrade
	%Cost.text = str(cost)

func _on_pressed() -> void:
	if Game.worms < cost:
		return
	
	Game.add_worm(-cost)
	Game.game.unlock_upgrade(upgrade)
	set_bought()

func set_bought():
	disabled = true
