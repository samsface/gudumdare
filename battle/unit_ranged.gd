class_name UnitRanged
extends Unit

@export var projectile_type := "arrow"

var projectile_scene: PackedScene
func _ready() -> void:
	if card:
		card.queue_free()
	projectile_scene = load("res://battle/projectiles/projectile_%s.tscn" % projectile_type)

func attack():
	GenericTween.attack($Model, global_position.direction_to(closest_enemy.position))
	
	var projectile: Projectile = projectile_scene.instantiate()
	get_parent().add_child(projectile)
	projectile.position = position
	projectile.init(battle, closest_enemy, is_foe)
