extends Area2D

func _on_zombie_triger_body_entered(body):
	if body.is_in_group("player"):
		var z_count:int = 0
		for z in get_children():
			if z.is_in_group("enemy"):
				z.active = true
				z_count += 1
		
		if z_count == 0:
			get_child(0).get_child(0).set_deferred("disabled", true)
			get_child(0).get_child(1).set_frame(1)
			get_child(0).get_child(2).play()
			get_child(1).set_deferred("disabled", true)
			get_child(2).set_deferred("disabled", true)
