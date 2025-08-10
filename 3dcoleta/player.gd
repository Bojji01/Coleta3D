extends CharacterBody3D
#variaveis de fisica
var gravity = 10
var speed = 5
#variaveis para o mecanica de carregar
var carrying := false
var carry_position = Node3D
var obj_carrying : RigidBody3D = null
#variaveis para o throw
var hold_time: float = 0
var hold_threshold: float = 1
var direction = -transform.basis.z
var throw_power := 10
var holding = false #variavel apra identificar se o player esta segurando o espaco

signal put_item()
signal get_item()
signal interact()

var aim = Node3D
func _ready() -> void:
	carry_position = $carry
	aim = $aim
	
func _physics_process(delta): #calcula a cada frame a fisica
	var direction = Vector3.ZERO
	
	if not is_on_floor(): # para saber se o objeto esta colidindo com o chao
		velocity.y -= gravity * delta #calculo para fazer personagem cair delta = cada frame
	else:
		velocity.y = 0

	if Input.is_action_pressed('ui_up'): #sintaxe para pegar o botao q o player aperta
		direction -= transform.basis.z # pega o eixo z
		aim.rotation_degrees.y = 0
	if Input.is_action_pressed('ui_down'):
		direction += transform.basis.z
		aim.rotation_degrees.y = 180
	if Input.is_action_pressed('ui_right'):
		direction += transform.basis.x
		aim.rotation_degrees.y = 270
	if Input.is_action_pressed('ui_left'):
		direction -= transform.basis.x
		aim.rotation_degrees.y = 90
	
	direction = direction.normalized() # manter a velocidade msm em diagonal
	velocity.z = direction.z * speed #calculo da velocidade na direcao
	velocity.x = direction.x * speed

	if Input.is_action_just_pressed("ui_accept"): #is_action_just_pressed para contar o input so 1x physcsprocess
		if not carrying :
			pickup_obj()
		else:
			carrying = true
			hold_time = 0
			holding = true
			
	if carrying and Input.is_action_pressed('ui_accept'):
		hold_time += delta
		
	if Input.is_action_just_released("ui_accept") and carrying and holding:
		if  hold_time >= hold_threshold :
			throw_obj()
		else :
			drop_obj()
	
	if Input.is_action_just_pressed("interact_key"):
		emit_signal('interact')
	
	if Input.is_action_just_pressed("interact_key") and carrying:
		emit_signal('put_item')
		
	if Input.is_action_just_pressed("interact_key") and not carrying:
		emit_signal('get_item')
		
	move_and_slide() #faz o personagem se mover usando velocidade e uma funcao do characterbody3d

func pickup_obj():
		#variaveis para o raycast
		var raycast = get_world_3d().direct_space_state #get_world_3d()pega a posicao do obj no mundo / .direct_space_state	para criar um raycast
		var from = aim.global_transform.origin # posicao inicial do raycast
		var to = from +- aim.transform.basis.z * 5.0 #posicao final do raycast (em z 5 unidades para frente)
		var query = PhysicsRayQueryParameters3D.create(from , to) #define como o raio vai ser lancado
		query.exclude = [self] # .exclude  faz com q o raycast ignore algo no caso vc msm 'self'
		var raycasted_obj = raycast.intersect_ray(query) #dispara o raycast com o parametro q ta dentro e retorna com os dados do primeira colisao
	
	
		if  raycasted_obj and raycasted_obj.collider is RigidBody3D: #confirma de o raycast atingiu um RigidBody3d
			obj_carrying = raycasted_obj.collider # atribui o objeto atingido no raycast na variavel
			obj_carrying.freeze = true # .freeze tira a fisica do objeto atingido
			obj_carrying.transform.origin = carry_position.global_transform.origin #coloca o objeto na posicao do Node carry q pre determinou
			obj_carrying.reparent(carry_position) #coloca o objeto dentro do Node carry
			carrying = true

func drop_obj():
	if carrying :
		obj_carrying.reparent(get_tree().root) # faz o obj voltar como filho do node3d main , da raiz
		obj_carrying.freeze = false 
		obj_carrying = null #reseta a variavel
		carrying = false
		holding = false

func throw_obj():
	obj_carrying.freeze = false
	obj_carrying.reparent(get_tree().root)
	var impulse = -$aim.global_transform.basis.z
	obj_carrying.apply_impulse(impulse * throw_power)
	obj_carrying = null
	carrying = false
	hold_time = 0
	holding = false

func put_obj():
	obj_carrying = null
	carrying = false
	hold_time = 0
	holding = false
