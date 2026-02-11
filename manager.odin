package main

import "core:log"
import "core:os"

MAX_ENTITIES :: 1024

Entity_Manager :: struct {
	items:      [MAX_ENTITIES]Entity,
	occupied:   [MAX_ENTITIES]bool,
	empty_slot: Idx,
	player_idx: Idx,
}

Entity_Iter :: struct {
	entities: []Entity,
	idx:      Idx,
}

get_player :: proc() -> ^Entity {
	return get(world.entities.player_idx)
}
get :: proc(idx: Idx) -> ^Entity {
	if idx == 0 {
		log.error("Attempted to `get` at idx = 0")
		return nil
	}

	return &world.entities.items[idx]
}

remove :: proc(idx: Idx) {
	if idx == 0 {
		log.error("Attempted to `remove` at idx = 0")
	}

	world.entities.items[idx] = Entity{}
	world.entities.occupied[idx] = false
}

load_entities_from_file :: proc() {
}

write_entities_to_file :: proc() {
	file_permissions := 0o644
	file_flags := os.O_CREATE | os.O_TRUNC | os.O_WRONLY

	file, error := os.open("data/entities.bin", file_flags, file_permissions)
	if error != nil {
		log.error("Failed to open 'entities.bin' for writing")
	}
	log.info("Opened file")
	defer os.close(file)

	value_bytes := transmute([size_of(Entity_Manager)]u8)world.entities
	bytes_written, write_err := os.write(file, value_bytes[:])
	if write_err != nil {
		log.errorf("Failed to write to 'data/entities.bin'\n%v", write_err)
	}

	log.infof("Wrote %v to 'data/entities.bin'", bytes_written)
}
