extends CharacterBody2D

@export var speed := 400.0

var facing_direction := Vector2.UP

func _physics_process(_delta):

	var direction := Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)

	velocity = direction * speed

	# Update facing only while moving
	if direction != Vector2.ZERO:
		facing_direction = direction
		$Sprite2D.rotation = facing_direction.angle() + deg_to_rad(90)
		
		if !$AnimationPlayer.is_playing():
			$AnimationPlayer.play("walk")
			
	else:
		$AnimationPlayer.stop()
		
	move_and_slide()
	
func enter_form(pos):
	visible = true
	set_physics_process(true)
	$CollisionShape2D.set_deferred("disabled", false)

	velocity = Vector2.ZERO
	position = pos

	facing_direction = Vector2.UP
	$Sprite2D.rotation = facing_direction.angle() + deg_to_rad(90)

	$AnimationPlayer.stop()

func exit_form():
	visible = false
	set_physics_process(false)
	$CollisionShape2D.set_deferred("disabled", true)

	velocity = Vector2.ZERO
	$AnimationPlayer.stop()
