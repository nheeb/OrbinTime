extends Spatial

var you_text := "You did it! You've built a planet!"
var but_text := ""

func set_but_text(mountains, trees, rivers):
	if !trees:
		but_text = "But it could use some trees..."
	elif !mountains:
		but_text = "But it could use some mountains..."
	elif !rivers:
		but_text = "But it could use some rivers..."
	else:
		but_text = "It is beautiful!"


var current_label: Label3D
var current_label_text : String
var current_label_pct := 0.0 setget set_label_pct

func _ready():
	visible = false
	$You.text = ""
	$But.text = ""

func set_label_pct(p):
	current_label_pct = p
	if !is_instance_valid(current_label):
		return
	var letter = int(current_label_pct * current_label_text.length())
	var snippet = current_label_text.substr(0, letter)
	current_label.text = snippet

func animate():
	$You.text = ""
	$But.text = ""
	$Click.visible = false
	$Thanks.visible = false
	visible = true
	current_label = $You
	current_label_text = you_text
	$Tween.interpolate_property(self, "current_label_pct", 0.0, 1.0, 2.5)
	$Tween.start()
	yield(get_tree().create_timer(5),"timeout")
	current_label = $But
	current_label_text = but_text
	$Tween.interpolate_property(self, "current_label_pct", 0.0, 1.0, 1.8)
	$Tween.start()
	yield(get_tree().create_timer(4),"timeout")
	if !but_text.begins_with("It"):
		$Click.visible = true
	else:
		$Thanks.visible = true
