extends KinematicBody2D

onready var bullet = preload("res://src/Bullet/Bullet.tscn")

const UP = Vector2(0, -1)
const DOWN = Vector2(0, 1)
const LEFT = Vector2(-1, 0)
const RIGHT = Vector2(1, 0)
const SPEED = 400
const DASH_SPEED = 1000

var direction = Vector2.ZERO
var shoot_direction = Vector2.ZERO

func _physics_process(delta):
	var old_direction = direction
	direction = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		direction += UP
	if Input.is_action_pressed("move_down"):
		direction += DOWN
	if Input.is_action_pressed("move_left"):
		direction += LEFT
	if Input.is_action_pressed("move_right"):
		direction += RIGHT
	move_and_collide(direction.normalized() * SPEED * delta)
	var shoot = false
	if Input.is_action_just_pressed("shoot_up"):
		shoot_direction = UP
		shoot = true
	if Input.is_action_just_pressed("shoot_down"):
		shoot_direction = DOWN
		shoot = true
	if Input.is_action_just_pressed("shoot_left"):
		shoot_direction = LEFT
		shoot = true
	if Input.is_action_just_pressed("shoot_right"):
		shoot_direction = RIGHT
		shoot = true
	if shoot:
		var instance = bullet.instance()
		instance.position = position
		instance.direction = shoot_direction
		get_tree().get_root().add_child(instance)
	if old_direction != direction:
		var dir = direction.normalized()
		var pos = position
		var packet = ("%s;1;%s,%s,%s,%s" % [global.client_id, str(pos.x), str(pos.y), str(dir.x), str(dir.y)]).to_ascii()
		get_parent().socketudp.put_packet(packet)
