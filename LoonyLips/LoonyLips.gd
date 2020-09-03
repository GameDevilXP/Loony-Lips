extends Control

var playerWords = []


var current_stories = {
	"prompts" : [],
	"story" : ""
}

onready var playerText = $VBoxContainer/HBoxContainer/PlayerText
onready var displayText = $VBoxContainer/DisplayText

# Checks the player words length, also triggers the loop.
# Also introduces the game to the player.
func _ready():
	set_current_stories()
	displayText.text = "Welcome to Loony Lips! We're going to tell a stories and have a wonderful time!  "
	check_player_words_length()
	playerText.grab_focus()


# sets a random stories
func set_current_stories():
	randomize()
	var stories = $StoryBook.get_child_count()
	var selected_story = randi() % stories
	current_stories.prompts = $StoryBook.get_child(selected_story).prompts
	current_stories.story = $StoryBook.get_child(selected_story).story


# Takes the input and appends it to the playerWords array once done.
func _on_PlayerText_text_entered(new_text):
	add_to_player_words()


# Takes the input and appends it to the playerWords array once done.
func _on_TextureButton_pressed():
	if is_stories_done():
		get_tree().reload_current_scene()
	else :
		add_to_player_words()


# Appends to the player words array and clears the playerText (lineEdit). 
# The loop ends here but it calls check_player_words to start the loop again.
func add_to_player_words():
	playerWords.append(playerText.text)
	displayText.text = ""
	playerText.clear()
	check_player_words_length()


func is_stories_done():
	return playerWords.size() == current_stories.prompts.size()


# Checks if the stories is done, if it is, it tells the stories, if not, it prompts the player.
func check_player_words_length():
	if is_stories_done():
		end_game()
	else:
		prompt_player()


# Tells the stories
func tell_stories():
	displayText.text = current_stories.story % playerWords


# prompts the player to type in a thingy
func prompt_player():
	displayText.text += "May I have " + current_stories.prompts[playerWords.size()] + " please"


# ends the game and tells the stories
func end_game():
	playerText.queue_free()
	tell_stories()
	$VBoxContainer/HBoxContainer/Label.text = "Again!"
