extends CharacterBody2D

var timer = 0.0;
var speed = 500;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position += Vector2(1, 0).rotated(rotation) * 25;
	scale = Vector2(0.2, 0.2)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta;
	if timer > 5:
		queue_free();
	velocity = Vector2(1, 0).rotated(rotation) * speed;
	move_and_slide();
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("rock"):
		body.hit();
		queue_free()
	pass # Replace with function body.
