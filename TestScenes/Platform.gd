extends Node2D
signal deleted

func _on_Death_body_entered(body):
	if body.is_in_group('character'):
		body.death(true)

func _on_Hit_body_entered(body):
	if body.is_in_group('character'):
		body.death(false)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_VisibilityNotifier2D_screen_entered():
	emit_signal("deleted", self)
