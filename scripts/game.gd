extends Node2D


# Called when the node enters the scene tree for the first time.

func _ready():
	
	$Cursor.exit_form()
	$Glider.exit_form()
	$TopDown.exit_form()

	FormManager.current_form = $Player
	FormManager.register($Player, $Player, $Cursor, $Glider, $TopDown)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		if FormManager.current_form == FormManager.player:
			FormManager.switch_form(FormManager.cursor, false)
		else:
			FormManager.switch_form(FormManager.player)
