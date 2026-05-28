extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_round()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func start_round():
	get_tree().paused = true
	await ScreenTransition.on_normal_transistion_finished
	get_tree().paused = false
	#Engine.set_time_scale(0.3)
	
func round_ending():
	
	ScreenTransition.transition()
	await ScreenTransition.on_transition_finished
	
	if Global.Score_P1 >= Global.Win_points_amount or Global.Score_P2 >= Global.Win_points_amount:
		Global.load_menu() # get to main_menu
		
	elif Global.Round_points_P1 >= 2 or Global.Round_points_P2 >= 2:
		Global.random_level() # winner decided
	else:
		Global.queue_free_bullets()
		get_tree().reload_current_scene() #round ending

	

	
