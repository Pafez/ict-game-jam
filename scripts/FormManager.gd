extends Node

var current_form = null

var player
var cursor
var glider
var top_down

func register(entry_node, player_node, cursor_node, glider_node, top_down_node, pos = null):
	player = player_node
	cursor = cursor_node
	glider = glider_node
	top_down = top_down_node

	current_form = entry_node
	if (pos == null):
		entry_node.enter_form()
	else:
		entry_node.enter_form(null)

func switch_form(new_form, should_set_pos = true):

	if current_form == new_form:
		return

	var spawn_position = Vector2.ZERO

	if current_form:
		spawn_position = current_form.get_spawn_position()
		current_form.exit_form()

	current_form = new_form
	
	if should_set_pos:
		current_form.set_spawn_position(spawn_position)
		current_form.enter_form()
	else:
		current_form.enter_form(spawn_position)
