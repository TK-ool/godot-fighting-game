extends Node

#create audioplayer and connect them to the buttons in the Scene

@onready var sounds = {
	"UI_Hover" : AudioStreamPlayer.new(),
	"UI_Click" : AudioStreamPlayer.new()
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in sounds.keys():
		sounds[i].stream = load("res://Sounds/UI_Sounds/" + str(i) + ".wav") #sounds müssen in diesem ordner hinterlegt werden und nach der Function die sie erfüllen benannt
		sounds[i].bus = "UI"
		add_child(sounds[i])
		
	install_sounds(get_parent()) # wo die funktion nach den buttons sucht


func install_sounds(node: Node) -> void:
	for i in node.get_children():
		if i is Button:
			i.mouse_entered.connect(func(): ui_sfx_play("UI_Hover"))
			i.pressed.connect(func(): ui_sfx_play("UI_Click"))
			i.focus_entered.connect(func(): ui_sfx_play("UI_Hover"))
		if i is HSlider:
			i.mouse_entered.connect(func(): ui_sfx_play("UI_Hover"))
			i.focus_entered.connect(func(): ui_sfx_play("UI_Hover"))
			
		#recoursion for children
		install_sounds(i)
			
			
			
func ui_sfx_play(sound: String):
	sounds[sound].play()
	
