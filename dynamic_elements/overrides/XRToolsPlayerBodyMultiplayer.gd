@tool
@icon("res://addons/godot-xr-tools/editor/icons/body.svg")
class_name XRToolsPlayerBodyMultiplayer
extends XRToolsPlayerBody

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set as toplevel means our PlayerBody is positioned in global space.
	# It is not moved when its parent moves.
	set_as_top_level(true)

	# Create our collision shape, height will be updated later
	var capsule = CapsuleShape3D.new()
	capsule.radius = player_radius
	capsule.height = 1.4
	_collision_node = CollisionShape3D.new()
	_collision_node.shape = capsule
	_collision_node.transform.origin = Vector3(0.0, 0.8, 0.0)
	add_child(_collision_node)

	# Create the shape-cast for head collisions
	_head_shape_cast = ShapeCast3D.new()
	_head_shape_cast.enabled = false
	_head_shape_cast.margin = 0.01
	_head_shape_cast.collision_mask = collision_mask
	_head_shape_cast.max_results = 1
	_head_shape_cast.shape = SphereShape3D.new()
	_head_shape_cast.shape.radius = player_radius
	add_child(_head_shape_cast)

	# MTZD - We can't use this for multiplayer as we are only interested in our local player
	# Get the movement providers ordered by increasing order
	
	#_movement_providers = get_tree().get_nodes_in_group("movement_providers")
	
	# MTZD - Using recursive search to get same elements but for this player only
	_movement_providers = get_group_nodes_on_branch("movement_providers", get_parent())
	
	_movement_providers.sort_custom(sort_by_order)

	# Propagate defaults
	_update_enabled()
	_update_player_radius()
	
# https://www.reddit.com/r/godot/comments/o90vpv/comment/h38fvzg - Thanks!

func get_group_nodes_on_branch(group: String, branch: Node) -> Array:
	var group_nodes_on_branch := []
	
	return get_group_nodes_on_branch_handler(group, branch, group_nodes_on_branch)
	
func get_group_nodes_on_branch_handler(_group: String, _branch: Node, group_nodes_on_branch: Array):
	for i in _branch.get_children():
		if i.is_in_group(_group):
			group_nodes_on_branch.append(i)
		if i.get_child_count() > 0:
			get_group_nodes_on_branch_handler(_group,i,group_nodes_on_branch)
	return group_nodes_on_branch
