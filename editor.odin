package main

// Editor Feature add collision for object
// 1. With object selected in editor
// 2. Click button to add collider
// 3. Choose between Sphere or poly
// 4. Show collider, for sphere, center and radius can be updated
// 5. For poly points can be moved freely

Editor_State :: struct {
	selected_object: ^Editor_Object,
	mode:            Editor_Mode,
}

Editor_Mode :: enum {
	Inspect,
	Place,
}

Editor_Object :: union {
	Collider,
}

Collider :: union {
	Collision_Sphere,
	Collision_Poly,
}

Collision_Poly :: struct {
	points: [8]f32,
}

Collision_Sphere :: struct {}
