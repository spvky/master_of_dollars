package main

import "core:fmt"
import "core:math"
import l "core:math/linalg"
import gm "shared:ghst/math"
import rl "vendor:raylib"

PI: f32 : f32(math.PI)
TAU: f32 : 2 * PI
HP: f32 : PI / 2

Vec2 :: [2]f32
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

cube_transform: Transform
sin_tester: Vec3

game_init :: proc() {
	init_assets()
	init_world()
	init_entities()
	rotation := l.quaternion_from_euler_angles_f32(45, 0, 22.5, .XYZ)
}

game_cleanup :: proc() {
	cleanup_entities()
}

game_render :: proc() {
	rl.BeginDrawing()
	rl.ClearBackground(rl.BLACK)
	rl.BeginMode3D(world.camera)
	rl.DrawCubeV(VEC_Z * 20, {40, 20, 1}, rl.RED)
	rl.DrawCubeV(VEC_Z * -20, {40, 20, 1}, rl.PINK)
	rl.DrawCubeV(VEC_X * 20, {1, 20, 40}, rl.BLUE)
	rl.DrawCubeV(VEC_X * -20, {1, 20, 40}, rl.GREEN)
	draw_entities()
	// angle, axis := l.angle_axis_from_quaternion_f32(cube_transform.rotation)
	// rl.DrawModelEx(
	// 	cube_model,
	// 	cube_transform.translation,
	// 	axis,
	// 	math.to_degrees(angle),
	// 	cube_transform.scale,
	// 	rl.WHITE,
	// )
	rl.DrawSphere(my_point, 0.2, rl.WHITE)
	draw_axis_gizmo(cube_transform)
	rl.EndMode3D()
	debug_overlay()
	target_overlay()
	rl.EndDrawing()
}

game_update :: proc() {
	update_camera()
	move_player()
	free_all(context.temp_allocator)
}

look_test :: proc() {
	delta := rl.GetFrameTime()
	time := f32(rl.GetTime())
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
	my_point += l.normalize0(move_delta) * 5 * delta
	cube_transform.rotation = l.quaternion_slerp(
		cube_transform.rotation,
		gm.look_at_point(cube_transform.translation, my_point),
		delta * 10,
	)
	interpolated := gm.interpolate_lateral_vector(cube_transform.rotation, {0, 1})
	sin_tester = interpolated * (math.sin(time) * 4)
}
