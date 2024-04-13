extends Area2D

var worm_count: int

func _ready():
	worm_count = $Worms.get_child_count()

func reveal_worms():
	for worm in $Worms.get_children():
		worm.reveal()
