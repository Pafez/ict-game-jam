extends Node2D

@onready var label = $Panel/Label

func _ready():
	$AnimationPlayer.play("pop_in")
	await $AnimationPlayer.animation_finished

	type_text("Catch me if you can!")

func type_text(text):
	label.text = ""

	for letter in text:
		label.text += letter
		await get_tree().create_timer(0.03).timeout
