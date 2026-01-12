extends RigidBody3D
class_name Player

@export_range(750, 2500) var force := 1000.0
@export var torque_thrust := 100.0

func _process(delta: float) -> void:
	
	if Input.is_action_pressed("boost"):
		apply_central_force(basis.y * delta * force)
		
	if Input.is_action_pressed("rotate_left"):
		apply_torque(Vector3(0, 0, delta*torque_thrust))
		
	if Input.is_action_pressed("rotate_right"):
		apply_torque(Vector3(0, 0, -delta*torque_thrust))


func _on_body_entered(body: Node) -> void:
	if "Goal" in body.get_groups():
		print("Win")
		if body.file_path:
			complete_level(body.file_path)
		else:
			print("no level")
	if "Hazard" in body.get_groups():
		crash_sequence()
		
func crash_sequence() -> void:
	print("kaboom")
	await get_tree().create_timer(2).timeout
	get_tree().reload_current_scene.call_deferred()

func complete_level(next_level_file) -> void:
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file.call_deferred(next_level_file)
