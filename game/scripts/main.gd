extends Control

func _on_btn_newgame_pressed():
	$popup.popup()
	print('Change scene to newgame')

func _on_btn_continue_pressed():
	print('Change scene to continue')

func _on_btn_options_pressed():
	print('Change scene to options')
