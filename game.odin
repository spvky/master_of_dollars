package main

import "core:fmt"
import "core:math"
import l "core:math/linalg"
import gm "shared:ghst/math"
import rl "vendor:raylib"

Vec3 :: [3]f32

my_point: Vec3

VEC_0: Vec3 : {0, 0, 0}
VEC_1: Vec3 : {1, 1, 1}
VEC_X: Vec3 : {1, 0, 0}
VEC_Y: Vec3 : {0, 1, 0}
VEC_Z: Vec3 : {0, 0, 1}

Game_Mode :: enum {
	Editor,
	Game,
}

cube_model: rl.Model
cube_transform: Transform

game_init :: proc() {
	init_world()
	fmt.printfln("%v", math.acos_f32(-2))
	cube_mesh := rl.GenMeshCube(1, 1, 1)
	cube_model = rl.LoadModelFromMesh(cube_mesh)
	rotation := l.quaternion_from_euler_angles_f32(45, 0, 22.5, .XYZ)
	// my_cube = make_cube(VEC_0, VEC_1, rotation)
	cube_transform = Transform {
		translation = VEC_X,
		rotation    = l.QUATERNIONF32_IDENTITY,
		scale       = VEC_1,
	}
}

game_render :: proc() {
	rl.BeginDrawing()
	rl.ClearBackground(rl.BLACK)
	rl.BeginMode3D(world.camera)
	angle, axis := l.angle_axis_from_quaternion_f32(cube_transform.rotation)
	rl.DrawModelEx(
		cube_model,
		cube_transform.translation,
		axis,
		math.to_degrees(angle),
		cube_transform.scale,
		rl.WHITE,
	)
	rl.DrawSphere(my_point, 0.2, rl.WHITE)
	draw_axis_gizmo(cube_transform)
	rl.EndMode3D()
	rl.EndDrawing()
}


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

game_update :: proc() {
	delta := rl.GetFrameTime()
	move_delta: Vec3
	if rl.IsKeyDown(.W) {
		move_delta.z -= 1
	}
	if rl.IsKeyDown(.A) {
		move_delta.x -= 1
	}
	if rl.IsKeyDown(.D) {
		move_delta.x += 1
	}
	if rl.IsKeyDown(.S) {
		move_delta.z += 1
	}

	if rl.IsKeyDown(.LEFT_CONTROL) {
		move_delta.y -= 1
	}
	if rl.IsKeyDown(.SPACE) {
		move_delta.y += 1
	}

	// rot := l.quaternion_from_euler_angle_y_f32((math.PI / 4) * delta)
	// cube_transform.rotation = l.normalize(cube_transform.rotation * rot)

	my_point += l.normalize0(move_delta) * 5 * delta
	// cube_transform.angle = math.acos_f32(cube_transform.c_value)
	cube_transform.rotation = l.quaternion_slerp(
		cube_transform.rotation,
		gm.look_at_point(cube_transform.translation, my_point),
		delta * 10,
	)
	// cube_transform.rotation = look_at_point(cube_transform.translation, my_point)

	// rot_matrix := l.matrix4_from_quaternion(cube_transform.rotation)
	//
	// point_in_front = l.quaternion_mul_vector3(cube_transform.rotation, VEC_Z)

}
