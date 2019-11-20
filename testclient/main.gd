extends Node

onready var other_player = preload("res://src/OtherPlayer/OtherPlayer.tscn")

var socketudp = PacketPeerUDP.new()
const SERVER_IP = "localhost"
const SERVER_PORT = 8000

func _ready():
	socketudp.set_dest_address(SERVER_IP, SERVER_PORT)
	
	# send connect packet
	var packet = ("0;0;").to_ascii()
	socketudp.put_packet(packet)
	
func _process(delta):
	if socketudp.is_listening():
		if socketudp.get_available_packet_count() > 0:
			var arr = socketudp.get_packet().get_string_from_ascii().split(";")
			print(arr)
			var identifier = arr[0]
			var opcode = arr[1]
			var data = arr[2]
			if opcode == "0":
				global.client_id = data
			elif opcode == "1":
				var params = data.split(",")
				var posX = params[0]
				var posY = params[1]
				var dirX = params[2]
				var dirY = params[3]
				var instance = get_tree().get_root().find_node(identifier, true, false)
				if instance:
					instance.position = Vector2(posX, posY)
					instance.direction = Vector2(dirX, dirY)
				elif global.client_id != identifier:
					var new_player = other_player.instance()
					new_player.name = identifier
					new_player.position = Vector2(posX, posY)
					get_tree().get_root().add_child(new_player)
			elif opcode == "3":
				print(data)
				var entities = data.split(",")
				for ent in entities:
					var params = data.split(":")
					identifier = params[0]
					var posX = params[1]
					var posY = params[2]
					var dirX = params[3]
					var dirY = params[4]
					var instance = get_tree().get_root().find_node(identifier, true, false)
					if instance:
						instance.position = Vector2(posX, posY)
						instance.direction = Vector2(dirX, dirY)
					elif global.client_id != identifier:
						var new_player = other_player.instance()
						new_player.name = identifier
						new_player.position = Vector2(posX, posY)
						get_tree().get_root().add_child(new_player)