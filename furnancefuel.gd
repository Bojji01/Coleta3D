extends Area3D

@onready var hud_fornalha : Control = $Hud_Fornalha
@onready var progress_bar : ProgressBar = $Hud_Fornalha/ProgressBar
@onready var camera: Camera3D = get_viewport().get_camera_3d() #pega a visao do jogador na camera do jogo
@onready var cooper_ore_sc = preload("res://Scene_Obj/cooper_ore.tscn")
@onready var crafting_out : Node3D = $crafting_out
var ore_inside: RigidBody3D
var cooling = 5
var last_fuel = 0
var item_time = 5
var craft_threshold = 0
var fuel = false
var ore_in = false
signal heated

func _process(delta):
	last_fuel += delta
	
	if last_fuel > 0.5 and progress_bar.value > 0:
		progress_bar.value -= cooling * delta

	if progress_bar.value >= 40 and ore_in:
		craft_threshold += delta

	if craft_threshold >= 3.0:
		item_heated()
		craft_threshold = 0
		
	if progress_bar.value == 0: #hud desaparecer quando a progress bar for a 0
		hud_fornalha.visible = false
	
func _on_body_entered(body: Node3D) -> void:
	if body is RigidBody3D and body.is_in_group(&"Ore"): #diferenca '==' compara o 'is' verifica se e do tipo
		ore_in = true
		ore_inside = body 
		await get_tree().create_timer(10.0).timeout
		ore_in = false
		ore_inside = null
		
func _on_fuel_body_entered(body: Node3D) -> void:
	if body is RigidBody3D and body.is_in_group(&'Fuel'):
		fuel = true
		var hud_position = camera.unproject_position(global_transform.origin) #retorna a cordenada n o viewport
		hud_fornalha.visible = true
		hud_fornalha.position = hud_position + Vector2(-60, -90)
		progress_bar.value += 60
		await get_tree().create_timer(10.0).timeout #timer para o delete do rigidbody
		body.queue_free() #deletar o rigidbody
		fuel = false


func item_heated():
	var heated := preload("res://Material/cooper_bar_heated.tres")
	var mesh := ore_inside.find_child("ore") as MeshInstance3D
	mesh.material_override = heated
	
	emit_signal('heated')
