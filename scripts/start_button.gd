extends Node2D

var hovered := false

func _on_area_2d_area_entered(area):
	if area.is_in_group("cursor"):
		hovered = true

func _on_area_2d_area_exited(area):
	if area.is_in_group("cursor"):
		hovered = false
