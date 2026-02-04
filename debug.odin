package main

import "core:fmt"
import l "core:math/linalg"
import "core:strings"
import rl "vendor:raylib"

debug_overlay :: proc() {
	rl.DrawFPS(0, 0)
	debug_camera()
}

debug_camera :: proc() {
	camera_string := fmt.tprintf(
		"Camera:\n\tPitch: %.3f\n\tYaw: %.3f",
		world.camera.pitch,
		world.camera.yaw,
	)

	rl.DrawText(
		strings.clone_to_cstring(camera_string, allocator = context.temp_allocator),
		0,
		32,
		12,
		rl.WHITE,
	)

	pitch, yaw, _ := l.pitch_yaw_roll_from_quaternion_f32(world.camera.rotation)


	potential_string := fmt.tprintf("Camera:\n\tPitch: %.3f\n\tYaw: %.3f", pitch, yaw)

	rl.DrawText(
		strings.clone_to_cstring(potential_string, allocator = context.temp_allocator),
		200,
		32,
		12,
		rl.WHITE,
	)

}
