extends Control

onready var players_select = find_node("OptionButton")

func _ready():
	for i in range(1, 5):
		players_select.add_item(str(i), i - 1)


func _on_start_pressed():
	var player_num = players_select.selected
	for i in range(0, player_num + 1):
		game_state.players.append({ "id": i, name: ""})

	SceneSwitcher.goto_scene("res://level1.tscn")


