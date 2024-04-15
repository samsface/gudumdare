class_name UnitRanged
extends Unit

@export var projectile_type := "arrow"

@export var burst := 1

var projectile_scene: PackedScene
func _ready() -> void:
	projectile_scene = load("res://battle/projectiles/projectile_%s.tscn" % projectile_type)
	super()

func attack():
	for i in burst:
		if has_node("Model"): #Attempt to fix crash at reward screen 
			GenericTween.attack($Model, global_position.direction_to(closest_enemy.position))
		
		var projectile: Projectile = projectile_scene.instantiate()
		get_parent().add_child(projectile)
		projectile.position = position
		projectile.init(battle, closest_enemy, is_foe)
		await get_tree().create_timer(0.05).timeout
