extends Node

const DEV = true

var multiplayer_peer = ENetMultiplayerPeer.new()
var url : String = "your-prod.url"
const PORT = 3333

var connected_peer_ids = []


func _ready():
	print("server _ready() called")
	#if DEV == true:
		#url = "127.0.0.1"
	#var error = multiplayer_peer.create_server(PORT)
	#print("create_server() returned " + str(error))
	#multiplayer.multiplayer_peer = multiplayer_peer
	#multiplayer_peer.peer_connected.connect(_on_peer_connected)
	#multiplayer_peer.peer_disconnected.connect(_on_peer_disconnected)
	#print("Server is up and running.")

func _on_start_server_button_pressed():
	print("server _on_start_server_button_pressed called")
	if DEV == true:
		url = "127.0.0.1"
	var error = multiplayer_peer.create_server(PORT)
	print("create_server() returned " + str(error))
	multiplayer.multiplayer_peer = multiplayer_peer
	multiplayer_peer.peer_connected.connect(_on_peer_connected)
	multiplayer_peer.peer_disconnected.connect(_on_peer_disconnected)
	print("Server is up and running.")

func _on_peer_connected(new_peer_id : int) -> void:
	print("server Player " + str(new_peer_id) + " is joining...")
	# The connect signal fires before the client is added to the connected
	# clients in multiplayer.get_peers(), so we wait for a moment.
	await get_tree().create_timer(1).timeout
	add_player(new_peer_id)


func add_player(new_peer_id : int) -> void:
	connected_peer_ids.append(new_peer_id)
	print("server Player " + str(new_peer_id) + " joined.")
	print("server Currently connected Players: " + str(connected_peer_ids))
	var error = rpc("sync_player_list", connected_peer_ids)
	print("result of rpc call to sync_player_list() is " + str(error))


func _on_peer_disconnected(leaving_peer_id : int) -> void:
	# The disconnect signal fires before the client is removed from the connected
	# clients in multiplayer.get_peers(), so we wait for a moment.
	await get_tree().create_timer(1).timeout 
	remove_player(leaving_peer_id)


func remove_player(leaving_peer_id : int) -> void:
	var peer_idx_in_peer_list : int = connected_peer_ids.find(leaving_peer_id)
	if peer_idx_in_peer_list != -1:
		connected_peer_ids.remove_at(peer_idx_in_peer_list)
	print("server Player " + str(leaving_peer_id) + " disconnected.")
	rpc("sync_player_list", connected_peer_ids)

@rpc
func sync_player_list(_updated_connected_peer_ids):
	print("sync_player_list() on server is being called :-( " + str(_updated_connected_peer_ids))

