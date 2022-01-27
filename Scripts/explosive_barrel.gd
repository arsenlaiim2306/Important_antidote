extends StaticBody2D

onready var anim:AnimationPlayer = $AnimationPlayer

func _ready():
	anim.play("start")

func explosive():
	anim.play("explosive")
	yield(anim, "animation_finished")
	queue_free()

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		body.dead()
	if body.is_in_group("enemy"):
		body.killed()
