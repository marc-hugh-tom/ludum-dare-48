extends KinematicBody2D

onready var _animated_sprite = $AnimatedSprite

func _ready():
	_animated_sprite.play("spin")
