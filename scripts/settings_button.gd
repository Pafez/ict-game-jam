extends StaticBody2D

func on_jabbed(_player):
	FormManager.switch_form(FormManager.top_down, false)
	$CollisionShape2D.set_deferred("disabled", true)
	queue_free()
