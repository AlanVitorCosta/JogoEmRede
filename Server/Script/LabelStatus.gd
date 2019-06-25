extends Label

const MAX_PLAYERS = 2
const MOVE_SPEED = 150
var p1_spawn_position = Vector2(100,350)
var p2_spawn_position = Vector2(0,0)

var players = []
var players_pos = []

func _ready():
	var network = NetworkedMultiplayerENet.new()
	network.create_server(4242, MAX_PLAYERS)
	get_tree().set_network_peer(network)
	
	network.connect("peer_connected",self,"_peer_connected")
	network.connect("peer_disconnected",self,"_peer_disconnected")
	players = get_tree().get_network_connected_peers()
	get_tree().multiplayer.connect("network_peer_packet",self,"_on_packet_received")
	pass

func _peer_connected(id):
	text = text + "\nUser " + str(id) + " connected"
	get_parent().get_node("LabelUserCount").text = "Total Users:" + str(get_tree().get_network_connected_peers().size())
	
	#envia a posição de spawn do player:
	get_tree().multiplayer.send_bytes(("spawnpos;" + str(p1_spawn_position.x) + ";" + str(p1_spawn_position.y)).to_ascii(), id)
	players_pos.append([id, p1_spawn_position]) 
	p1_spawn_position.x + 100
	
	#informa aos outros players a sua posição:
	for i in get_tree().get_network_connected_peers():
		if i != id:
			var textToSend = ("newOther;" + str(players_pos[-1][1].x) + ";" + str(players_pos[-1][1].y))
			get_tree().multiplayer.send_bytes(textToSend.to_ascii(), i)
			print(textToSend)
	pass
	
func spawn_others(id):
	get_tree().multiplayer.send_bytes(("spawnotherp;" + str(get_tree().get_network_connected_peers().size())).to_ascii(), id)
	print("a" + str(get_tree().get_network_connected_peers().size()))
	pass
	
	
func _on_packet_received(id,packet):
	var msg = packet.get_string_from_ascii().split(';')
	if msg[0] == "movedir":
		update_player_position(Vector2(msg[1], msg[2]), id)
	elif msg[0] == "mespawnei":
		spawn_others(id)
#		for i in get_tree().get_network_connected_peers():
#			if i != id:
				
	elif msg[0] == "newPos":
		var textToSend = "updateOthersPos;"
		var textComplemento = ""
		for i in players_pos:
			if i[0] == id:
				i[1] = Vector2(msg[1], msg[2])
			else:
				textComplemento = str(i[1].x) + ";" + str(i[1].y) + ";"
		textToSend = textToSend + textComplemento
		update_others_position(id, textToSend)
	pass
	
func _peer_disconnected(id):
	text = text + "\nUser " + str(id) + " disconnected"
	get_parent().get_node("LabelUserCount").text = "Total Users:" + str(get_tree().get_network_connected_peers().size())

func update_others_position(id, textToSend):
	get_tree().multiplayer.send_bytes(textToSend.to_ascii(), id)
	pass
	
func _process(delta):
	#print(players_pos)
	#var players = get_tree().get_network_connected_peers()
	pass
	
func update_player_position(movedir, id):
	var motion = movedir.normalized() * MOVE_SPEED
	get_tree().multiplayer.send_bytes(("p1posupdate;" + str(motion.x) + ";" + str(motion.y)).to_ascii(), id)
	pass
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
func old_update_position(i):
	#var motion = movedir.normalized() * SPEED
	var motion = Vector2(1,0).normalized() * MOVE_SPEED
	var id_pos = players_pos[i]
	get_tree().multiplayer.send_bytes(("p1posupdate;" + str(motion.x) + ";" + str(motion.y)).to_ascii(), id_pos[0])
	#get_tree().multiplayer.send_bytes(("p1pos;" + str(id_pos[1].x) + ";" + str(id_pos[1].y)).to_ascii(), id_pos[0])
	pass