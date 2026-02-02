package main

import "core:fmt"
import "core:math"
import l "core:math/linalg"
import gm "shared:ghst/math"
import rl "vendor:raylib"

Camera :: struct {
	using raw:  rl.Camera3D,
	rotation:   Quat,
	pitch, yaw: f32,
}

Camera_Mode :: enum {
	Free,
	Locked,
}

update_camera :: proc() {
	delta := rl.GetFrameTime()
	camera := &world.camera

	rot_y, rot_x: f32

	if rl.IsKeyDown(.RIGHT) {
		rot_y -= 1
	}
	if rl.IsKeyDown(.LEFT) {
		rot_y += 1
	}
	if rl.IsKeyDown(.UP) {
		rot_x -= 1
	}
	if rl.IsKeyDown(.DOWN) {
		rot_x += 1
	}

	camera.pitch += (math.PI / 4) * delta * rot_y
	camera.yaw += (math.PI / 4) * delta * rot_x

	tp := f32(math.PI * 2)

	if camera.pitch < -tp {
		camera.pitch += tp
	}

	if camera.pitch > tp {
		camera.pitch -= tp
	}

	rotation_y := l.quaternion_from_euler_angle_y_f32(camera.pitch)
	rotation_x := l.quaternion_from_euler_angle_x_f32(camera.yaw)
	camera.rotation = l.normalize(l.QUATERNIONF32_IDENTITY * rotation_y * rotation_x)

	// Regardless of camera mode, we set the target based on the camera's forward vector, the goal is to never update target otherwise in order to have the cameras rotation be consistent and observable anywhere
	cam_forward := l.normalize0(l.quaternion_mul_vector3(camera.rotation, VEC_Z))
	camera.target = camera.position + cam_forward
}
