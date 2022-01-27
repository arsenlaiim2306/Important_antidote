extends KinematicBody2D

var speed:float = 1600
export var active:bool = true

onready var legs:AnimatedSprite = $legs
onready var body_sprite:Sprite = $body

onready var ray:RayCast2D = $body/RayCast2D
onready var anim:AnimationPlayer = $AnimationPlayer
onready var gun_sound:AudioStreamPlayer2D = $AudioStreamPlayer2D 

func _ready():
	anim.play("start")

func _process(_delta):
	if active:
		body_sprite.look_at(get_global_mouse_position())

func _physics_process(delta):
	if active:
		if Input.is_action_just_pressed("mouse_left") && !anim.is_playing():
			anim.play("shot")
			gun_sound.play()
			if ray.is_colliding():
				if ray.get_collider().is_in_group("enemy"):
					ray.get_collider().killed()
				if ray.get_collider().is_in_group("explosive"):
					ray.get_collider().explosive()
			
		
		var move:Vector2 = Vector2()
		move.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		move.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		
		if move != Vector2():
			legs.play("run")
			legs.look_at(position+move)
		else:
			legs.play("stay")
		
		move *= speed
		move = move_and_slide(move*delta)
	else:
		legs.play("stay")

func _on_Area_body_entered(body):
	if body.is_in_group("enemy") && active:
		dead()

func _on_antidote_body_entered(body):
	if body.is_in_group("player"):
		active = false
		anim.play("game_win")

func dead():
	anim.play("dead")
	yield(anim, "animation_finished")
	print(get_tree().change_scene("res://Scenes/main.tscn"))
