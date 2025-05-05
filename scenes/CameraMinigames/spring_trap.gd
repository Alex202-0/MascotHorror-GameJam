extends Node2D

var found : Array[bool] = [false,false,false,false]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(delta: float) -> void:
	$afton.physics_process(delta)


func _on_chica_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		$chica/Label.visible = true
		found[0] = true
func _on_chica_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		$chica/Label.visible = false
func _on_bonnie_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		found[1] = true
		$bonnie/Label.visible = true
func _on_bonnie_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		$bonnie/Label.visible = false
func _on_foxy_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		found[2] = true
		$foxy/Label.visible = true
func _on_foxy_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		$foxy/Label.visible = false
func _on_freddy_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		$freddy/Label.visible = true
		found[3] = true
func _on_freddy_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		$freddy/Label.visible = false
