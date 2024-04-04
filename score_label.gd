extends Label

var score = 0

func _on_game_food_eaten():
	score += 1
	text = "Score: %s" % score
