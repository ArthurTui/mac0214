extends Control


func _on_Play_pressed():
	$fade.play("fade_out")


func play_scene():
	get_tree().change_scene("res://menus/CSS.tscn")


func _on_Quit_pressed():
	get_tree().quit()