extends Node3D

const PLAYERS = preload("uid://eybnci8tomx0")

func _ready() -> void:
	_spawn_player(-1)
	
	var pads = Input.get_connected_joypads()
	
	for id in pads:
		_spawn_player(id)

func _spawn_player(id:int):
	var p:Player = PLAYERS.instantiate()
	p.device_id = id
	add_child(p)
