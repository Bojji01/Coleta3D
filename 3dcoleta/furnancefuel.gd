extends Area3D

@onready var hud_fornalha : Control = $Hud_Fornalha
@onready var progress_bar : ProgressBar = $Hud_Fornalha/ProgressBar
@onready var camera: Camera3D = get_viewport().get_camera_3d() #pega a visao do jogador na camera do jogo
@onready var cooper_bar_sc = preload("res://Scene_Obj/cooper_bar.tscn")
@onready var crafting_out : Node3D = $crafting_out
var cooling = 5
var last_fuel = 0
var item_time = 5
var craft_threshold = 0

func _process(delta):
	last_fuel += delta
	
	if last_fuel > 0.5 and progress_bar.value > 0:
		progress_bar.value -= cooling * delta

	if progress_bar.value >= 40:
		craft_threshold += delta
		print(craft_threshold)
	
	if craft_threshold >= 3.0:
		item_crafted()
		craft_threshold = 0
		
	if progress_bar.value == 0: #hud desaparecer quando a progress bar for a 0
		hud_fornalha.visible = false
	
func _on_body_entered(body: Node3D) -> void:
	if body is RigidBody3D: #diferenca '==' compara o 'is' verifica se e do tipo
		var hud_position = camera.unproject_position(global_transform.origin) #retorna a cordenada n o viewport
		hud_fornalha.visible = true
		hud_fornalha.position = hud_position + Vector2(-60, -90)
		progress_bar.value += 60
		await get_tree().create_timer(3.0).timeout #timer para o delete do rigidbody
		body.queue_free() #deletar o rigidbody
		
		
func item_crafted():
	var cooper_bar = cooper_bar_sc.instantiate()
	get_tree().get_current_scene().add_child(cooper_bar) #colocar o objeto instanciado na cena
	cooper_bar.global_transform.origin = crafting_out.global_transform.origin
	cooper_bar.apply_impulse(Vector3(1,1,0).normalized() * 3) # pro objeto pular de ladinho
