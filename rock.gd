extends Upgrade

@onready var rockBody = $RigidBody2D
@onready var textLabel = $RigidBody2D/Bubble/RichTextLabel
# Has a visible_ratio property that can be modified w/ Tween
# for scrolling effect.

var speechDict: Dictionary[int, String] = {
	0: "Hello there.",
	1: "It rocks to rock!",
	2: "...",
	3: "It’s a hard rock life for us.",
	4: "Have you filed our taxes yet?",
	6: "The moon landing never happened.",
	7: "I'm really fun at parties.",
	8: "I'm thinking of running for Congress.",
	9: "Wanna see my Spotify Wrapped?"
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
