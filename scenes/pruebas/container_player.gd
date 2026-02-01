extends Node

var list_players:Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	list_players = get_children()
	_select_human()


func _select_human() -> void:
	var n_ramdom = randi_range(0, list_players.size() - 1)
	
	for i in range(list_players.size()):
		if n_ramdom == i:
			list_players[i].set_as_human()
		else:
			list_players[i].set_as_monster()
		
