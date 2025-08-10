extends Node3D
var mining_rock = preload("res://Scene_Obj/mining_rock.tscn")
@onready var timer = $Timer
var tempo_spawn = 2
var limite_mine = 3
var total_mine = 0
@onready var spawn_area : Area3D = $spawn_mining

func _ready() -> void:
	timer.wait_time = tempo_spawn
	timer.start()
	
func _on_timer_timeout() -> void:
	if total_mine < limite_mine:
		mine_rock_spawn()

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
