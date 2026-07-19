extends StaticBody2D

func on_jabbed(_player):
	FormManager.switch_form(FormManager.cursor, false)
