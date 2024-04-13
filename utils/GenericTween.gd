extends Node
class_name GenericTween

static func shake(node:Node2D) -> Tween:
	var tween = node.create_tween()
	for i in 5:
		tween.tween_property(node, "position:x", node.position.x - 5, 0.1)
		tween.tween_property(node, "position:x", node.position.x + 5, 0.1)
	
	return tween


static func squish(node:Node2D) -> Tween:
	var tween = node.create_tween()
	tween.tween_property(node, "scale:y", 0.9, 0.1)
	tween.tween_property(node, "scale:y", 1.0, 0.1)
	
	return tween
