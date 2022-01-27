extends KinematicBody2D

var active:bool = false
var speed:float = 1400

var path:PoolVector2Array

onready var nav:Navigation2D = 			get_parent().get_parent().get_parent().get_child(0)
onready var player:KinematicBody2D = 	get_parent().get_parent().get_parent().get_child(1)

onready var anim:AnimatedSprite = 		$AnimatedSprite

func _ready():
	rotation_degrees = rand_range(0, 360)
	speed = rand_range(800, 1600)

func _physics_process(delta):
	if active:
		anim.play("walk")
		if global_position.distance_to(player.global_position) < 60 || (player.ray.is_colliding() && player.ray.get_collider() == self):
			path = nav.get_simple_path(global_position, player.global_position)
		
		if path.size() > 1:
			look_at(path[1])
			var move:Vector2 = global_position.direction_to(path[1])
			move *= speed * delta
			move = move_and_slide(move)
	else:
		anim.play("stay")

func killed():
	active = false
	anim.set_scale(Vector2(0.4, 0.4))
	$Particles2D.restart()
	$CollisionShape2D.set_deferred("disabled", true)
	yield(get_tree().create_timer(0.4), "timeout")
	anim.set_visible(false)
	yield(get_tree().create_timer(0.6), "timeout")
	queue_free()
