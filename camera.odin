package main

import "core:fmt"
import "core:math"
import l "core:math/linalg"
import gm "shared:ghst/math"
import rl "vendor:raylib"

Camera :: struct {
	using raw:       rl.Camera3D,
	target_rotation: Quat,
	rotation:        Quat,
	pitch, yaw:      f32,
	mode:            Camera_Mode,
	lockon_target:   int,
}

Camera_Mode :: enum {
	Free,
	Locked,
	Cutscene,
}

update_camera :: proc() {
	delta := rl.GetFrameTime()
	camera := &world.camera

	if rl.IsKeyPressed(.L) {
		switch camera.mode {
		case .Free:
			camera.mode = .Locked
		case .Locked:
			camera.mode = .Free
			yaw := l.yaw_from_quaternion_f32(camera.rotation)
			// camera.pitch = math.clamp(pitch, -HP, HP)
			camera.pitch = 0
			camera.yaw = yaw

			for camera.yaw < -TAU {
				camera.yaw += TAU
			}

			for camera.yaw > TAU {
				camera.yaw -= TAU
			}
		case .Cutscene:
		}
	}

	switch camera.mode {
	case .Free:
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


		camera.yaw += (math.PI / 4) * delta * rot_y

		new_pitch := camera.pitch + ((math.PI / 4) * delta * rot_x)
		camera.pitch = math.clamp(new_pitch, -HP, HP)


		if camera.yaw < -TAU {
			camera.yaw += TAU
		}

		if camera.yaw > TAU {
			camera.yaw -= TAU
		}

		rotation_y := l.quaternion_from_euler_angle_y_f32(camera.yaw)
		rotation_x := l.quaternion_from_euler_angle_x_f32(camera.pitch)
		camera.target_rotation = l.normalize(l.QUATERNIONF32_IDENTITY * rotation_y * rotation_x)
		camera.position = VEC_Y + world.player.translation
	case .Locked:
		target_translation := entity_center(world.entities[camera.lockon_target])
		camera.target_rotation = gm.look_at_point(camera.position, target_translation)
		camera.position = VEC_Y + world.player.translation
	case .Cutscene:
	}
	// Slerp the camera rotation
	camera.rotation = l.quaternion_slerp(camera.rotation, camera.target_rotation, 10 * delta)
	// Regardless of camera mode, we set the target based on the camera's forward vector, the goal is to never update target otherwise in order to have the cameras rotation be consistent and observable anywhere
	cam_forward := l.normalize0(l.quaternion_mul_vector3(camera.rotation, VEC_Z))
	camera.target = camera.position + cam_forward
}
