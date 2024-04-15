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
		$AudioNot.play()
		return
	$AudioBuy.play()
	Game.add_worm(-cost)
	Game.game.unlock_upgrade(upgrade)
	set_bought()

func set_bought():
	$Panel.queue_free()
	disabled = true

func _process(delta: float) -> void:
	if not disabled:
		%Cost.modulate = Color.LAWN_GREEN if Game.worms >= cost else Color.FIREBRICK
