extends Node

const DEV = true

@onready var connect_btn = $ConnectButton
@onready var disconnect_btn = $DisconnectButton

var multiplayer_peer = ENetMultiplayerPeer.new()
var url : String = "your-prod.url"
const PORT = 3333

var connected_peer_ids = []


func _ready():
	print("client _ready() called")
	if DEV == true:
		url = "127.0.0.1"
	update_connection_buttons()
	multiplayer.server_disconnected.connect(_on_server_disconnected)

#@rpc
#func sync_player_list(updated_connected_peer_ids):
	#print("sync_player_list() called on client!")
	#connected_peer_ids = updated_connected_peer_ids
	#multiplayer_peer.get_unique_id()
	#update_connection_buttons()
	#print("client Currently connected Players: " + str(connected_peer_ids))


func _on_connect_button_pressed() -> void:
	print("Connecting ...")
	var error = multiplayer_peer.create_client(url, PORT)
	print("create_client returned: " + str(error))
	multiplayer.multiplayer_peer = multiplayer_peer
	


func _on_disconnect_button_pressed() -> void:
	multiplayer_peer.close()
	update_connection_buttons()
	print("Disconnected.")


func _on_server_disconnected():
	multiplayer_peer.close()
	update_connection_buttons()
	print("Connection to server lost.")


func update_connection_buttons() -> void:
	print("update_connection_buttons() invoked")
	#if multiplayer_peer.get_connection_status() == multiplayer_peer.CONNECTION_DISCONNECTED:
		#connect_btn.disabled = false
		#disconnect_btn.disabled = true
	#if multiplayer_peer.get_connection_status() == multiplayer_peer.CONNECTION_CONNECTING:
		#connect_btn.disabled = true
		#disconnect_btn.disabled = true
	#if multiplayer_peer.get_connection_status() == multiplayer_peer.CONNECTION_CONNECTED:
		#connect_btn.disabled = true
		#disconnect_btn.disabled = false

