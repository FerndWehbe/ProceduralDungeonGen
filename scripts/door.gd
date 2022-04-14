extends Area2D


signal entered_door


func _on_Door_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("entered_door")
