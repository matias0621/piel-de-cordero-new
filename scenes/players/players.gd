class_name Player
extends CharacterBody3D

@export var speed:float = 10
@export var acceleration:float = 20
@export var device_id:int = -1
@export var monster_animation:MonsterAnimation
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var _name_animations:NameAnimationMonster = NameAnimationMonster.new()
@onready var mask_node: CharacterBody3D = $Mask

var is_mask_thrown: bool = false

func _ready() -> void:
	print(device_id)

func _process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	var input_dir = MultiplayerInput.get_vector(device_id ,"player_one_right", "player_one_left", "player_one_down", "player_one_up")
	
	if Input.is_action_pressed("ui_accept"):
		monster_animation.play_animation(_name_animations.shock)
	
	if MultiplayerInput.is_action_just_pressed(device_id,"shoot_mask") and not is_mask_thrown:
		_throw_mask()
	
	if input_dir != Vector2.ZERO:
		velocity.x = lerp(velocity.x, input_dir.x * speed, acceleration * delta)
		velocity.z = lerp(velocity.z, input_dir.y * speed ,acceleration * delta)
		var dir_3d = Vector3(input_dir.x, 0, input_dir.y).normalized()
		var target_rotation = atan2(dir_3d.x, dir_3d.z) + PI
		rotation.y = lerp_angle(rotation.y, target_rotation, 8 * delta) 
		
		monster_animation.play_animation(_name_animations.run)
	else:
		velocity.x = 0
		velocity.z = 0
		monster_animation.play_animation(_name_animations.idle)
	
	move_and_slide()

func _throw_mask():
	is_mask_thrown = true
	
	# 1. Detach from player and add to the world so it doesn't move WITH the player
	var world = get_parent()
	var start_pos = mask_node.global_position
	remove_child(mask_node)
	world.add_child(mask_node)
	mask_node.global_position = start_pos

	# 2. Logic for throwing
	var throw_distance = 10
	var target_position = global_transform.origin - global_transform.basis.z * throw_distance


	while mask_node.global_position.distance_to(target_position) > 0.1:
		mask_node.global_position = mask_node.global_position.move_toward(target_position, 20 * get_process_delta_time())
		await get_tree().process_frame

	await get_tree().create_timer(1.0).timeout
	_return_mask()

func _return_mask():
	mask_node.set_collision_layer(0)
	mask_node.set_collision_mask(0)

	while mask_node.global_position.distance_to(global_transform.origin) > 0.5:
		# Move toward the player's current position
		mask_node.global_position = mask_node.global_position.move_toward(global_transform.origin, 25 * get_process_delta_time())
		await get_tree().process_frame

	# 3. Re-attach to player and reset local position
	mask_node.get_parent().remove_child(mask_node)
	add_child(mask_node)
	
	# Reset to your specific coordinates
	mask_node.position = Vector3(0, 0.5, -2.5)
	mask_node.rotation = Vector3.ZERO
	
	mask_node.set_collision_layer(1)
	mask_node.set_collision_mask(1)
	is_mask_thrown = false
