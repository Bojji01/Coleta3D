extends Node3D

var mining_rock = preload("res://Scene_Obj/mining_rock.tscn")
var enemy_minion_swordsc = preload("res://Minions/enemy_minion_sword.tscn")
@onready var enemy_spawn_point: Node3D = $spawn_enemy_minion
@onready var timer = $Timer
@onready var spawn_area : Area3D = $spawn_mining
@onready var camera : Camera3D = $Camera3D
@onready var cameratf : Camera3D = $CameraTF
var tempo_spawn = 2
var limite_mine = 3
var total_mine = 0

func _ready() -> void:
	timer.wait_time = tempo_spawn
	timer.start()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed('ui_change_camera'):
			cameratf.make_current()
	if Input.is_action_just_released('ui_change_camera'): #controle da camera
			camera.make_current()

func _on_timer_timeout() -> void:
	if total_mine < limite_mine:
		mine_rock_spawn()
		
func _on_timer_spawn_timeout() -> void:
	Enemy_spawn()

func mine_rock_spawn():
	var mine = mining_rock.instantiate()
	var mine_position = mine_random_spawn()
	get_tree().get_current_scene().add_child(mine)
	total_mine += 1
	mine.global_position = mine_position
	mine.tree_exited.connect(_on_mine_mined) #identifica quando o objeto spawnado 'saiu / exclido' da cena e chama a funcao

func mine_random_spawn(): #funcao para o spawm
	var area = spawn_area.get_node("CollisionShape3D").shape
	if area is BoxShape3D:
		var extents = area.size / 2.0
		var rand_x = randf_range(- extents.x , extents.x) #gera random do eixo x e z
		var rand_z = randf_range(- extents.z , extents.z)
		return spawn_area.global_position + Vector3(rand_x , 0.4 , rand_z)
	else:
		return spawn_area.global_position

func _on_mine_mined(): #diminui o limite quando o obj e minerado
	total_mine -= 1

func Enemy_spawn():
	var enemy_minion_sword = enemy_minion_swordsc.instantiate()
	get_tree().get_current_scene().add_child(enemy_minion_sword) #colocar o objeto instanciado na cena
	call_deferred('spawn_enemy_minion', enemy_minion_sword)
	print('minion spawnado')

func spawn_enemy_minion(minion = RigidBody3D):
	minion.position = enemy_spawn_point.position
