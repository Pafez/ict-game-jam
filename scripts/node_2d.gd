extends Node2D

@export var scroll_speed: float = 100.0 * 0
@export var texture_width: float = 1024.0  # width of your background image in px

@onready var bg1 = $Background1
@onready var bg2 = $Background2
@onready var camera = $Camera2D

var pos2
var offset1
var offset2

func _ready():
	pos2 = bg2.position.x - camera.position.x
	offset2 = pos2
	offset1 = 0
	
func _process(delta):
	bg1.position.x = offset1 + camera.position.x
	bg2.position.x = offset2 + camera.position.x
	
	offset1 -= scroll_speed * delta
	offset2 -= scroll_speed * delta

	if offset1 <= -pos2:
		offset1 = pos2
	if offset2 <= -pos2:
		offset2 = pos2
		
	
	
	camera.position.x += 0
