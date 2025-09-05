extends RigidBody3D

var speed = 10
var direction: Vector3 = Vector3(1,0,0)
var hp = 5
@onready var camera: Camera3D = $CameraTF
@onready var barra_hp : ProgressBar = $HP_minion/ProgressBar
@onready var Hold_hp_bar : Node3D = $Hold_hp_bar


func _process(delta: float) -> void:
	var cam := get_viewport().get_camera_3d()
	if cam == null:
		barra_hp.visible = false
		return
	var world_pos: Vector3 = Hold_hp_bar.global_transform.origin
	var screen_pos : Vector2 = cam.unproject_position(world_pos)
	
	barra_hp.position = screen_pos + Vector2(-90 , -40)
	barra_hp.visible = true
	 
func _physics_process(delta: float) -> void:
	linear_velocity = direction.normalized() * speed

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group('minion'):
		hp -= 1
		barra_hp.value -= 50
		print(hp)
		if hp <= 0:
			self.queue_free()
	if body.is_in_group('minion'):
		body.queue_free()
