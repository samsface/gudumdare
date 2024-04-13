class_name Card
extends Node2D

@export var card_name: String = "CARD"
var battle: Battle

@export var unit = "unit_knight"
@export var mana_cost := 2

func init(battle):
	self.battle = battle
	%Name.text = card_name
	%Cost.text = str(mana_cost)


func summon():
	var unit = load("res://battle/units/%s.tscn" % unit).instantiate()
	battle.add_unit(unit, get_global_mouse_position())


func _process(delta: float) -> void:
	if battle.dragging_card == self:
		global_position = get_global_mouse_position()
		if Input.is_action_just_released("LMB"):
			release()
		scale = scale.lerp(
				Vector2.ONE * (0.5 if position.y < -100 else 1.0),
				min(delta * 30.0, 1.0)
		)
	else:
		position = lerp(
				position,
				battle.get_card_position(self),
				min(delta * 10.0, 1.0)
		)
		scale = scale.lerp(Vector2.ONE * 0.8, min(delta * 10.0, 1.0) )


func grab():
	battle.dragging_card = self

func release():
	battle.dragging_card = null
	if position.y < -100 and battle.mana > mana_cost:
		battle.mana -= mana_cost
		battle.put_card(self)
		position = Vector2(0, 200)
		summon()
	else:
		# put back to deck
		position = battle.get_card_position(self)


func _on_area_brush_2d_mouse_pressed() -> void:
	if battle.dragging_card != null:
		return
	grab()
