class_name Card
extends Node2D

var battle: Battle
var data: CardData

func init(data: CardData, battle):
	self.data = data
	self.battle = battle
	%Name.text = data.name


func summon():
	var unit = battle.UNIT.instantiate()


func _process(delta: float) -> void:
	if battle.dragging_card == self:
		global_position = get_global_mouse_position()
		if Input.is_action_just_released("LMB"):
			release()
	else:
		position = lerp(
				position,
				battle.get_card_position(self),
				delta * 10.0
		)


func grab():
	battle.dragging_card = self

func release():
	battle.dragging_card = null
	if position.y > -200:
		# put back to deck
		position = battle.get_card_position(self)
	else:
		battle.put_card(self)
		position = Vector2(0, 200)
		summon()


func _on_area_brush_2d_mouse_pressed() -> void:
	if battle.dragging_card != null:
		return
	grab()
