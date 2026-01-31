class_name MonsterAnimation
extends Node3D

@export var _animationPlayer:AnimationPlayer


func play_animation(animation: String):
	if animation == "Corriendo":
		_animationPlayer.speed_scale = 1.8
	else :
		_animationPlayer.speed_scale = 1
	_animationPlayer.play(animation)
