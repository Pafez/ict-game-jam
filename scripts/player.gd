extends CharacterBody2D

var pushback_timer := 0.0

@export var pushback_time := 0.15

@export var speed := 300.0
@export var jump_velocity := -350.0
@export var push_back_velocity := 300

@export var dash_speed := 800.0
@export var dash_time := 0.15

var is_dashing := false
var can_dash := true

var is_inserted := false
var insert_direction := 0 # -1 = left wall, 1 = right wall
var inserted_body: StaticBody2D = null
var last_body_position: Vector2

var original_scale_x

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var jabber_hitbox = $JabberArea/JabberHitbox

func _ready():
	jabber_hitbox.disabled = true
	original_scale_x = scale.x

func _physics_process(delta):
	# ---------------- INSERTED ----------------
	if is_inserted:

		# Follow moving platform
		if inserted_body:
			var delta_pos = inserted_body.global_position - last_body_position
			global_position += delta_pos
			last_body_position = inserted_body.global_position

		velocity = Vector2.ZERO

		# Pull out
		if Input.is_action_just_pressed("move_left") and insert_direction == 1:
			is_inserted = false

		elif Input.is_action_just_pressed("move_right") and insert_direction == -1:
			is_inserted = false

		# Jump off
		elif Input.is_action_just_pressed("jump"):
			is_inserted = false
			pushback_timer = pushback_time
			
			velocity.y = jump_velocity
			velocity.x = push_back_velocity * -insert_direction

		move_and_slide()
		return
	
	# ---------------- DASH ----------------
	if Input.is_action_just_pressed("dash") and can_dash and !is_dashing:
		start_dash()

	if is_dashing:
		move_and_slide()
		return


	# ---------------- GRAVITY ----------------
	if !is_on_floor():
		velocity.y += gravity * delta


	# ---------------- JUMP ----------------
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# ---------------- MOVEMENT ----------------
	var direction = Input.get_axis("move_left", "move_right")

	# Update facing direction regardless
	if direction > 0:
		$Sprite2D.flip_h = false
	elif direction < 0:
		$Sprite2D.flip_h = true

	# Only block horizontal movement while pushback is active
	if pushback_timer > 0:
		pushback_timer -= delta
	else:
		if direction:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed * 2)


	# ---------------- ROTATION ----------------
	if is_dashing:
		if $Sprite2D.flip_h:
			$Sprite2D.rotation_degrees = -45
		else:
			$Sprite2D.rotation_degrees = 45

	elif is_on_floor() or direction:
		$Sprite2D.rotation_degrees = 0

	else:
		if $Sprite2D.flip_h:
			$Sprite2D.rotation_degrees = 45
		else:
			$Sprite2D.rotation_degrees = -45


	move_and_slide()

	if is_on_floor():
		can_dash = true


func start_dash():

	is_dashing = true
	can_dash = false

	# ENABLE hitbox while dashing
	jabber_hitbox.disabled = false

	if $Sprite2D.flip_h:
		$Sprite2D.rotation_degrees = -45
	else:
		$Sprite2D.rotation_degrees = 45

	var dash_direction = -1 if $Sprite2D.flip_h else 1

	velocity.x = dash_direction * dash_speed
	velocity.y = 0

	await get_tree().create_timer(dash_time).timeout

	if !is_inserted:
		is_dashing = false
		jabber_hitbox.disabled = true


func insert_into_wall(body):
	inserted_body = body
	last_body_position = body.global_position
	
	is_inserted = true
	is_dashing = false

	# Save which side we're stuck in
	insert_direction = -1 if $Sprite2D.flip_h else 1

	velocity = Vector2.ZERO

	set_deferred("jabber_hitbox.disabled", true)
	can_dash = true
		
func _on_jabber_area_body_entered(body):
	print("Hit:", body.name)
	if !is_dashing:
		return

	if body.is_in_group("insertable"):
		insert_into_wall(body)
		
	if body.is_in_group("activatable") and body.has_method("on_jabbed"):
			body.on_jabbed(self)
			return
	
func enter_form():
	visible = true
	set_physics_process(true)

	# Reset movement
	velocity = Vector2.ZERO

	# Reset states
	is_dashing = false
	is_inserted = false
	can_dash = true

	# Clear insertion data
	inserted_body = null
	insert_direction = 0

	# Disable jabber hitbox
	jabber_hitbox.disabled = true

	# Reset sprite
	$Sprite2D.rotation_degrees = 0

func exit_form():
	visible = false
	set_physics_process(false)

func get_spawn_position():
	return global_position

func set_spawn_position(pos):
	global_position = pos
