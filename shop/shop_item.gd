extends Button

@export var upgrade := ""
@export var cost := 0

func _ready() -> void:
	if Game.game.upgrades.has(upgrade):
		set_bought()
	%ItemName.text = upgrade
	%Cost.text = str(cost)

func _on_pressed() -> void:
	if Game.worms < cost:
		$AudioNot.play()
		blink_cost()
		return
	$AudioBuy.play()
	Game.add_worm(-cost)
	Game.game.unlock_upgrade(upgrade)
	set_bought()

func set_bought():
	%Cost.queue_free()
	disabled = true

func blink_cost():
	for i in 3:
		%CostContainer.modulate = Color.WHITE * 2.0
		await get_tree().create_timer(0.1).timeout
		%CostContainer.modulate = Color.WHITE
		await get_tree().create_timer(0.1).timeout

func _process(delta: float) -> void:
	if not disabled:
		%Cost.modulate = Color.LAWN_GREEN if Game.worms >= cost else Color.FIREBRICK


func _on_mouse_entered() -> void:
	$AudioHover.play()
