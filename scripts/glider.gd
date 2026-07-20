extends CharacterBody2D

@export var forward_speed := 400.0
@export var gravity := 900.0
@export var thrust := 700.0
@export var max_fall_speed := 700.0
@export var rotation_strength := 0.08
@export var max_rotation := 35.0

func _physics_process(delta):

	# Always move forward
	velocity.x = forward_speed

	# Ship controls
	if Input.is_action_pressed("jump"):
		velocity.y -= thrust * delta
	else:
		velocity.y += gravity * delta

	velocity.y = clamp(velocity.y, -max_fall_speed, max_fall_speed)
	
	# Rotate depending on vertical speed
	$Sprite2D.rotation_degrees = clamp(
		velocity.y * rotation_strength,
		-max_rotation,
		max_rotation
	)

	move_and_slide()
	
func enter_form(pos):
	visible = true
	set_physics_process(true)
	$CollisionShape2D.set_deferred("disabled", false)

	velocity = Vector2.ZERO
	position = pos

func exit_form():
	visible = false
	set_physics_process(false)
	$CollisionShape2D.set_deferred("disabled", true)

	velocity = Vector2.ZERO
