extends Node

var Player = preload("res://player.tscn")

onready var game_viewer = $GameViewer

func _ready():
	game_viewer.screen_num = game_state.players.size()
	game_viewer.setup_screens()

	var spawner = game_viewer.world_instance.get_node("spawner")
	for i in range(game_state.players.size()):
		var player = game_state.players[i]
		var player_node = Player.instance()
		player_node.id = player.id
		
		var camera = game_viewer.viewports[i].get_node("Camera2D")
		if game_state.players.size() > 1: # zoom out when there are multiple players
			camera.zoom = Vector2(1.5, 1.5)
			
		game_viewer.world_instance.add_child(player_node)
		player_node.position = spawner.position + Vector2(player_node.id + 10, 0)
		camera.target = player_node
	
	set_camera_limits(game_viewer.world_instance, game_viewer.viewports)

func set_camera_limits(world, viewports):
	var map = world.get_node("tile_map")
	var map_limits = map.get_used_rect()
	var map_cellsize = map.cell_size

	for viewport in viewports:
		var cam = viewport.get_node("Camera2D")
		cam.limit_left = map_limits.position.x * map_cellsize.x
		cam.limit_right = map_limits.end.x * map_cellsize.x
		cam.limit_top = map_limits.position.y * map_cellsize.y
		cam.limit_bottom = map_limits.end.y * map_cellsize.y
