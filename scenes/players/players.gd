class_name Player
extends CharacterBody3D

@export var speed:float = 10
@export var acceleration:float = 20
@export var device_id:int = -1
@export var monster_animation:MonsterAnimation
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var _name_animations:NameAnimationMonster = NameAnimationMonster.new()


func _ready() -> void:
	print(device_id)

func _process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	var input_dir = MultiplayerInput.get_vector(device_id ,"player_one_right", "player_one_left", "player_one_down", "player_one_up")
	
	if Input.is_action_pressed("ui_accept"):
		monster_animation.play_animation(_name_animations.shock)
	
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
