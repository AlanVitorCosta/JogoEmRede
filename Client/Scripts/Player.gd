extends KinematicBody2D


var movedir = Vector2(0,0)

func controls_loop():
	var LEFT = Input.is_action_pressed("ui_left")
	var RIGHT = Input.is_action_pressed("ui_right")
	var UP = Input.is_action_pressed("ui_up")
	var DOWN = Input.is_action_pressed("ui_down")

	movedir.x = -int(LEFT) + int(RIGHT)
	movedir.y = -int(UP) + int(DOWN)
	
	var textToSend = "movedir;" + str(movedir.x) + ";" + str(movedir.y)
	get_tree().multiplayer.send_bytes(textToSend.to_ascii())
	pass

func movment_update(motion):
	move_and_slide(motion, Vector2(0,0))
	pass
	
func _ready():
	pass 

func _physics_process(delta):
	controls_loop()
	pass
