extends RigidBody3D

@onready var anvil = $"../anvil"
@onready var furnance = $"../furnancefuel"
@onready var mesh00 : MeshInstance3D = $ore
@onready var mesh01 : MeshInstance3D = $ore01
var heated = false

func _ready() -> void:
	furnance.heated.connect(_on_furnance_heated)

func _on_anvil_cooperore_50():
	mesh01.visible = true
	mesh00.visible = false

func _on_furnance_heated():
	heated = true
	
