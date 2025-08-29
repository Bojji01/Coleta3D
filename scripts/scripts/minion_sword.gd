extends RigidBody3D

var speed = 10
var direction: Vector3 = Vector3(1,0,0)

func _physics_process(delta: float) -> void:
	linear_velocity = direction.normalized() * speed

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group('minion'):
		print('hitado')
		body.queue_free()
