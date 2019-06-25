extends KinematicBody2D
#var movedir = Vector2(0,0)

func _ready():
	pass

func movment_update(motion):
	move_and_slide(motion, Vector2(0,0))
	pass