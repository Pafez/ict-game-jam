extends Node2D

signal clicked

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(_delta):
	global_position = get_global_mouse_position()

func _unhandled_input(event):
	if event.is_action_pressed("click"):
		clicked.emit()

func _exit_tree():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func enter_form(pos):

	visible = true
	set_process(true)

	global_position = pos

	var viewport = get_viewport()
	var screen_pos = viewport.get_canvas_transform() * pos

	DisplayServer.warp_mouse(screen_pos)

func exit_form():
	visible = false
	set_process(false)

func get_spawn_position():
	return global_position

func set_spawn_position(pos):
	global_position = pos
