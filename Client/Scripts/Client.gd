extends Node2D
var player_scene = preload("res://Scenes/Player.tscn")
var other_player = preload("res://Scenes/OtherPlayer.tscn")
var player
var other_players = []
var others_spawnados = false

func _ready():
	#var network = NetworkedMultiplayerENet.new()
	#network.create_client("127.0.0.1", 4242)
	#get_tree().set_network_peer(network)
	#network.connect("connection_failed",self,"_on_connection_failed")
	get_tree().multiplayer.connect("network_peer_packet",self,"_on_packet_received")
	pass
	
func _on_connection_failed(error):
	$labelStatus.text = "Error connecting to server " + error
	
func _on_packet_received(id,packet):
	var msg = packet.get_string_from_ascii().split(';')
	if msg[0] == "spawnpos":
		$LabelServerData.text = packet.get_string_from_ascii()
		player = player_scene.instance()
		get_tree().get_root().add_child(player)
		player.position = Vector2(int(msg[1]), int(msg[2]))
		var textToSend = "mespawnei"
		get_tree().multiplayer.send_bytes(textToSend.to_ascii())
	elif msg[0] == "spawnotherp":
		for i in range(int(msg[1]) - 1):
			var other = other_player.instance()
			get_tree().get_root().add_child(other)
			other.position = Vector2(0, 0)
			other_players.append(other)
		others_spawnados = true
	elif msg[0] == "newOther":
		var other = other_player.instance()
		get_tree().get_root().add_child(other)
		other.position = Vector2(msg[1], msg[2])
		other_players.append(other)
	elif msg[0] == "p1posupdate":
		$LabelServerData.text = packet.get_string_from_ascii()
		player.movment_update(Vector2(int(msg[1]), int(msg[2])))
		var textToSend = "newPos;" + str(player.position.x) + ";" + str(player.position.y)
		get_tree().multiplayer.send_bytes(textToSend.to_ascii())
	elif msg[0] == "updateOthersPos" and others_spawnados == true:
		var size = msg.size() - 2
		if(msg.size() > 2):
			for i in range(msg.size()):
				if msg[i] != msg[0] and msg[i] != msg[-1] and other_players.size() == 1:
					var otherPosition = Vector2(msg[1], msg[2])
					other_players[0].position = otherPosition
		#print(msg.size())
	elif msg[0] != "movedir" and msg[0] != "mespawnei" and msg[0] != "newPos":
		$LabelServerData.text = packet.get_string_from_ascii()
		
