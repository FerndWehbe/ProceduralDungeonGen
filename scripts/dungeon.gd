extends Node2D

var borders = Rect2(1, 1, 38, 21)

onready var tilemap = $DungeonRoom
onready var player_spawn_position: Vector2 = Vector2.ZERO
onready var last_room

func _ready():
	randomize()
	generate_level()


func generate_level():
	var walker = Dungeon_Walker.new(Vector2(19, 11), borders)
	var num_tiles: int = int(rand_range(100, 300))

	var map = walker.walk(num_tiles)
	player_spawn_position = map.front() * 32

	walker.queue_free()

	for location in map:
		tilemap.set_cellv(location, 0)
	
	tilemap.update_bitmask_region()
	last_room = walker.get_farway_room()


func reload_level():
	return get_tree().reload_current_scene()
