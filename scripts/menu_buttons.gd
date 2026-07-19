extends Node2D

@export var normal_texture: Texture2D
@export var hover_texture: Texture2D

@onready var sprite: Sprite2D = $Sprite2D

func _on_area_2d_area_entered(area):
	if area.is_in_group("cursor"):
		sprite.texture = hover_texture

func _on_area_2d_area_exited(area):
	if area.is_in_group("cursor"):
		sprite.texture = normal_texture
