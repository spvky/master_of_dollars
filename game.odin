package main

import "core:fmt"
import "core:math"
import l "core:math/linalg"
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


// Returns a quaternion from `origin` looking at `target`, only rotating on the y-axis
look_at_point_raw :: proc(origin, target: Vec3) -> Quat {
	forward := l.normalize0(target - origin)
	half_angle := math.acos(l.dot(VEC_Z, forward)) * 0.5
	axis := l.normalize0(l.cross(VEC_Z, forward))
	qi := axis * math.sin(half_angle)
	return transmute(Quat)[4]f32{qi.x, qi.y, qi.z, math.cos(half_angle)}
}

// Returns a quaternion from `origin` looking at `target` with an up vector of `up_vector`
look_at_point :: proc(origin, target: Vec3, up_vector: Vec3 = VEC_Y) -> Quat {
	forward := l.normalize0(target - origin)
	up := l.normalize0(forward - up_vector * forward.y)

	pitch, yaw := l.QUATERNIONF32_IDENTITY, l.QUATERNIONF32_IDENTITY
	// yaw
	if up.x != 0 {
		half_angle_yaw := math.acos(l.dot(VEC_Z, up)) * 0.5
		rot_axis := forward.x > 0 ? VEC_Y : -VEC_Y
		//Quat axes
		qa := rot_axis * math.sin(half_angle_yaw)
		yaw = transmute(Quat)[4]f32{qa.x, qa.y, qa.z, math.cos(half_angle_yaw)}
	} else if up.z < 0 {
		yaw = transmute(Quat)[4]f32{0, math.sin_f32(math.PI * 0.5), 0, math.cos_f32(math.PI * 0.5)}
	}
	// pitch
	if forward.y != 0 {
		if l.length2(up) != 0 {
			half_angle_pitch := math.acos(l.dot(forward, up)) * 0.5
			rot_axis := forward.y < 0 ? VEC_X : -VEC_X
			//Quat axes
			qa := rot_axis * math.sin(half_angle_pitch)
			pitch = transmute(Quat)[4]f32{qa.x, qa.y, qa.z, math.cos_f32(half_angle_pitch)}
		} else {
			pitch = transmute(Quat)[4]f32 {
				math.sin_f32(math.PI * 0.25),
				0,
				0,
				math.cos_f32(math.PI * 0.25),
			}
		}
	}
	return yaw * pitch
}


draw_axis_gizmo :: proc(
	transform: Transform,
	handle_length: f32 = 3,
	handle_scale: f32 = 0.1,
	local: bool = true,
) {
	x, y, z: Vec3
	if local {
		x =
			transform.translation +
			l.normalize0(l.quaternion_mul_vector3(transform.rotation, VEC_X)) * handle_length
		y =
			transform.translation +
			l.normalize0(l.quaternion_mul_vector3(transform.rotation, VEC_Y)) * handle_length
		z =
			transform.translation +
			l.normalize0(l.quaternion_mul_vector3(transform.rotation, VEC_Z)) * handle_length
	} else {
		x = transform.translation + VEC_X * handle_length
		y = transform.translation + VEC_Y * handle_length
		z = transform.translation + VEC_Z * handle_length
	}
	rl.DrawSphere(x, handle_scale, rl.BLUE)
	rl.DrawLine3D(transform.translation, x, rl.BLUE)
	rl.DrawSphere(y, handle_scale, rl.GREEN)
	rl.DrawLine3D(transform.translation, y, rl.GREEN)
	rl.DrawSphere(z, handle_scale, rl.RED)
	rl.DrawLine3D(transform.translation, z, rl.RED)
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
		move_delta.y += 1
	}
	if rl.IsKeyDown(.SPACE) {
		move_delta.y -= 1
	}

	rot := l.quaternion_from_euler_angle_y_f32((math.PI / 4) * delta)
	cube_transform.rotation = l.normalize(cube_transform.rotation * rot)

	my_point += l.normalize0(move_delta) * 5 * delta
	// cube_transform.angle = math.acos_f32(cube_transform.c_value)
	cube_transform.rotation = look_at_point(cube_transform.translation, my_point)

	// rot_matrix := l.matrix4_from_quaternion(cube_transform.rotation)
	//
	// point_in_front = l.quaternion_mul_vector3(cube_transform.rotation, VEC_Z)

}
