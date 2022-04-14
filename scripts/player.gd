extends KinematicBody2D
class_name Player


var SPEED: int = 200
var velocity: Vector2 = Vector2.ZERO


func _physics_process(_delta):
	var input_dir = _player_direction()
	velocity = input_dir * SPEED
	_move()


func _player_direction() -> Vector2:
	var input_dir: Vector2 = Vector2.ZERO

	input_dir.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_dir.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	input_dir = input_dir.normalized()

	return input_dir


func _move() -> void:
	velocity = move_and_slide(velocity)
