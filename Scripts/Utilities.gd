extends Node2D

func get_main_node():
	var root_node = $"/root"
	return root_node.get_child(root_node.get_child_count() - 1)