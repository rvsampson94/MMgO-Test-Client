extends KinematicBody2D

const SPEED = 600
export var direction = Vector2.ZERO

func _physics_process(delta):
	move_and_collide(direction.normalized() * SPEED * delta)
