extends Node2D


onready var PLAYER = preload("res://scenes/player.tscn")
onready var DUNGEON = preload("res://scenes/dungeon.tscn")
onready var NEXT_DOOR = preload("res://scenes/door.tscn")

onready var level: int = 0

var actual_dungeon
var next_door
var player

func _ready():
	new_level_dungeon()

func new_level_dungeon():
	if actual_dungeon:
		actual_dungeon.queue_free()
	actual_dungeon = DUNGEON.instance()
	call_deferred("add_child", actual_dungeon)

	# Set Player
	player = PLAYER.instance()
	actual_dungeon.call_deferred("add_child", player)
	
	# Set door
	next_door = NEXT_DOOR.instance()
	actual_dungeon.call_deferred("add_child", next_door)
	next_door.connect("entered_door", self, "enter_next_level")

	# Wait node is ready
	yield(actual_dungeon, "ready")
	player.position = actual_dungeon.player_spawn_position
	next_door.position = actual_dungeon.last_room.position * 32

	player.get_node("Label").text = "Level " + str(level + 1)


func enter_next_level():
	level += 1
	new_level_dungeon()
