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
	cursor_pos:      Vec2,
}

Camera_Mode :: enum {
	Free,
	Locked,
	Cutscene,
}

update_camera :: proc() {
	delta := rl.GetFrameTime()
	camera := &world.camera

	if rl.IsKeyPressed(.LEFT_CONTROL) {
		switch camera.mode {
		case .Free:
			camera.mode = .Locked
		case .Locked:
			camera.mode = .Free
			// yaw := l.yaw_from_quaternion_f32(camera.rotation)
			// camera.pitch = math.clamp(pitch, -HP, HP)
			camera.pitch = 0
			// camera.yaw = yaw
			dir := l.normalize0(
				entity_center(world.entities[camera.lockon_target]) - camera.position,
			)
			angle := math.atan2(dir.z, dir.x)

			camera.yaw = angle

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
		mouse_delta := l.normalize0(rl.GetMouseDelta())

		camera.yaw += look_speed() * delta * -mouse_delta.x

		new_pitch := camera.pitch + (look_speed() * delta * mouse_delta.y)
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
		camera.cursor_pos = Vec2{f32(SCREEN_WIDTH) / 2, f32(SCREEN_HEIGHT) / 2}
	case .Locked:
		target_translation := entity_center(world.entities[camera.lockon_target])
		camera.target_rotation = gm.look_at_point(camera.position, target_translation)
		camera.position = VEC_Y + world.player.translation
	case .Cutscene:
	}
	// Slerp the camera rotation
	camera.rotation = l.quaternion_slerp(camera.rotation, camera.target_rotation, 50 * delta)
	// Regardless of camera mode, we set the target based on the camera's forward vector, the goal is to never update target otherwise in order to have the cameras rotation be consistent and observable anywhere
	cam_forward := l.normalize0(l.quaternion_mul_vector3(camera.rotation, VEC_Z))
	camera.target = camera.position + cam_forward
}

handle_cursor :: proc() {
	delta := rl.GetFrameTime()
	mouse_delta := rl.GetMouseDelta()
	crosshair_pos := &world.camera.cursor_pos
	center := Vec2{f32(SCREEN_WIDTH) / 2, f32(SCREEN_HEIGHT) / 2}


	switch world.camera.mode {
	case .Locked:
		crosshair_pos^ += delta * lockon_sensitivity() * mouse_delta
		pos_to_center := crosshair_pos^ - center
		if l.length(pos_to_center) > f32(SCREEN_HEIGHT) / 2.4 {
			norm := l.normalize0(pos_to_center)
			crosshair_pos^ = center + (norm * (f32(SCREEN_HEIGHT) / 2.4))
		}
	case .Free:
		crosshair_pos^ = center
	case .Cutscene:
	}

}
