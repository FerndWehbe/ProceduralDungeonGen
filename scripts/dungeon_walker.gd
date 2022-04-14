extends Node
class_name Dungeon_Walker


const DIRECTIONS: Array = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]


var position: Vector2
var actual_direction: Vector2

# Array for place positions of tile inside dungeon
var valid_positions: Array = []

# Positions desde a ultima mudança de posição
var positions_since_turns: int = 0

# Format and dimension of dungeon
var borders: Rect2 = Rect2()

# Rooms of Dungeon
var rooms: Array = []


func _init(starting_position: Vector2, new_borders: Rect2) -> void:
	# If starting position is not inside in area of dungeon, returns a error
	assert(new_borders.has_point(starting_position))

	position = starting_position
	valid_positions.append(position)

	borders = new_borders


func walk(steps: int) -> Array:
	for step in steps:
		if positions_since_turns >= 6:
			change_direction()

		if step():
			valid_positions.append(position)
		else:
			change_direction()

	return valid_positions


func step() -> bool:
	var target_position: Vector2 = position + actual_direction
	if borders.has_point(target_position):
		positions_since_turns += 1
		position = target_position
		return true
	return false


func change_direction() -> void:
	place_room(position)
	positions_since_turns = 0
	var directions: Array = DIRECTIONS.duplicate()
	directions.erase(actual_direction)
	directions.shuffle()
	actual_direction = directions.pop_front()
	while not borders.has_point(position + actual_direction):
		actual_direction = directions.pop_front()


func place_room(position_room: Vector2) -> void:
	var size: Vector2 = Vector2(int(rand_range(3, 6)), int(rand_range(3, 6)))
	rooms.append(create_room(position_room, size))
	var top_left_corner: Vector2 = (position_room - size / 2).ceil()
	for x in size.x:
		for y in size.y:
			var new_position = top_left_corner + Vector2(x, y)
			if borders.has_point(new_position):
				valid_positions.append(new_position)


func get_farway_room() -> Dictionary:
	var far_room: Dictionary = rooms.pop_front()
	var starting_room: Vector2 = valid_positions.front()
	for room in rooms:
		if starting_room.distance_to(room.position) > starting_room.distance_to(far_room.position):
			far_room = room
	return far_room


func create_room(position_room: Vector2, size: Vector2) -> Dictionary:
	return {position = position_room, size = size}
