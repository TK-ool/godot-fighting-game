extends Node

var Win_points_amount := 3

var Score_P1 := 0
var Score_P2 := 0

var Round_points_P1 := 0
var Round_points_P2 := 0

var menu = "uid://bi2nmmbvx00ww"

var all_level = [
	"uid://dlr1yhmdr3wkh",
	"uid://cnieqsgkay365"
]

func load_menu():
	Score_reset()
	round_points_reset()
	load(menu)
	get_tree().change_scene_to_file(menu)

func random_level():
	round_points_reset()
	var x = randi() % all_level.size()
	var selected_scene = all_level[x]
	load(selected_scene)
	get_tree().change_scene_to_file(selected_scene)
	
func round_points_reset():

	Round_points_P1 = 0
	Round_points_P2 = 0
	
func Score_reset():
	Score_P1 = 0
	Score_P2 = 0
