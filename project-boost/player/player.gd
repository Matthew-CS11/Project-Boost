extends RigidBody3D
class_name Player

@export_range(750, 2500) var force := 1000.0
@export var torque_thrust := 100.0

@onready var explosion_audio: AudioStreamPlayer = $ExplosionAudio
@onready var success_audio: AudioStreamPlayer = $SuccessAudio
@onready var rocket_audio: AudioStreamPlayer3D = $RocketAudio
@onready var main_booster: GPUParticles3D = $MainBooster
@onready var left_booster: GPUParticles3D = $LeftBooster
@onready var right_booster: GPUParticles3D = $RightBooster

var transitioning := false

func _process(delta: float) -> void:
	if !transitioning:
		if Input.is_action_pressed("boost"):
			apply_central_force(basis.y * delta * force)
			main_booster.emitting = true
			if !rocket_audio.is_playing():
				rocket_audio.play()
		else:
			rocket_audio.stop()
			main_booster.emitting = false
		if Input.is_action_pressed("rotate_left"):
			apply_torque(Vector3(0, 0, delta*torque_thrust))
			right_booster.emitting = true
		else:
			right_booster.emitting = false
		if Input.is_action_pressed("rotate_right"):
			apply_torque(Vector3(0, 0, -delta*torque_thrust))
			left_booster.emitting = true
		else:
			left_booster.emitting = false

func _on_body_entered(body: Node) -> void:
	if !transitioning:
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
	explosion_audio.play()
	main_booster.emitting = false
	right_booster.emitting = false
	left_booster.emitting = false
	rocket_audio.stop()
	transitioning = true
	await get_tree().create_timer(2).timeout
	get_tree().reload_current_scene.call_deferred()

func complete_level(next_level_file) -> void:
	transitioning = true
	success_audio.play()
	main_booster.emitting = false
	right_booster.emitting = false
	left_booster.emitting = false
	rocket_audio.stop()
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file.call_deferred(next_level_file)
