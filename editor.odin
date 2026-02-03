package main

import l "core:math/linalg"
import rl "vendor:raylib"

draw_axis_gizmo :: proc(
	transform: Transform,
	handle_length: f32 = 3,
	handle_scale: f32 = 0.1,
	local: bool = true,
) {
	right, up, forward: Vec3
	x, y, z: Vec3

	if local {
		x = l.normalize0(l.quaternion_mul_vector3(transform.rotation, VEC_X))
		right = transform.translation + x * handle_length
		y = l.normalize0(l.quaternion_mul_vector3(transform.rotation, VEC_Y))
		up = transform.translation + y * handle_length
		z = l.normalize0(l.quaternion_mul_vector3(transform.rotation, VEC_Z))
		forward = transform.translation + z * handle_length
	} else {
		right = transform.translation + VEC_X * handle_length
		up = transform.translation + VEC_Y * handle_length
		forward = transform.translation + VEC_Z * handle_length
	}
	rl.DrawSphere(right, handle_scale, rl.BLUE)
	rl.DrawLine3D(transform.translation, right, rl.BLUE)
	rl.DrawSphere(up, handle_scale, rl.GREEN)
	rl.DrawLine3D(transform.translation, up, rl.GREEN)
	rl.DrawSphere(forward, handle_scale, rl.RED)
	rl.DrawLine3D(transform.translation, forward, rl.RED)
}
// Editor Feature add collision for object
// 1. With object selected in editor
// 2. Click button to add collider
// 3. Choose between Sphere or poly
// 4. Show collider, for sphere, center and radius can be updated
// 5. For poly points can be moved freely

// Editor_State :: struct {
// 	selected_object: ^Editor_Object,
// 	mode:            Editor_Mode,
// }
//
// Editor_Mode :: enum {
// 	Inspect,
// 	Place,
// }
//
// Editor_Object :: union {
// 	Collider,
// }
//
// // Collider :: union {
// // 	Collision_Sphere,
// // 	Collision_Poly,
// // }
//
// Collision_Poly :: struct {
// 	points: [8]f32,
// }
//
// Collision_Sphere :: struct {}
