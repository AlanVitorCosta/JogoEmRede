extends Button

func _ready():
	pass
func _on_ButtonSendData_pressed():
	print("Sending data to client")
	var textToSend = "Server: " + get_parent().get_node("TextToSend").text
	get_tree().multiplayer.send_bytes(textToSend.to_ascii())
	
	#var players = get_tree().get_network_connected_peers()
	#get_tree().multiplayer.send_bytes("oi".to_ascii(), players[0])