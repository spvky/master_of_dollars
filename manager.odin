package main

import "core:log"
import "core:os"

MAX_ENTITIES :: 1024

Entity_Ptr :: #soa^#soa[MAX_ENTITIES]Entity

Entity_Manager :: struct {
	items:      #soa[MAX_ENTITIES]Entity,
	used:       [MAX_ENTITIES]bool,
	empty_slot: Idx,
	player_idx: Idx,
}

Entity_Iter :: struct {
	entities: []Entity,
	idx:      Idx,
}

init_entities :: proc() {
	entities := &world.entities
	entities.used[0] = true
	entities.empty_slot = 1
	spawn_player({50, 50})
}

get_player :: proc() -> Entity_Ptr {
	return get(world.entities.player_idx)
}

add :: proc(e: Entity) -> Idx {
	entities := &world.entities
	for i in 1 ..< entities.empty_slot {
		if !entities.used[i] {
			entities.used[i] = true
			entities.items[i] = e
			return i
		}
	}
	if entities.empty_slot > MAX_ENTITIES {
		log.warn("Max entities in collection, returning nil idx")
		return 0
	}
	entities.used[entities.empty_slot] = true
	entities.items[entities.empty_slot] = e
	idx_to_return := entities.empty_slot
	entities.empty_slot += 1
	return idx_to_return
}

get :: proc(idx: Idx) -> Entity_Ptr {
	if idx == 0 && world.entities.used[idx] {
		log.error("Attempted to `get` at idx = 0")
		return nil
	}

	return &world.entities.items[idx]
}

// Unit test this
shrink_entities :: proc() {
	entities := &world.entities
	holes: Idx
	last_full_slot: Idx
	for i in 1 ..< entities.empty_slot {
		if entities.used[i] {
			last_full_slot = i
			entities.items[i - holes] = entities.items[i]
		} else {
			holes += 1
		}
	}
	entities.empty_slot = last_full_slot
}

remove :: proc(idx: Idx) {
	if idx == 0 {
		log.error("Attempted to `remove` at idx = 0")
	}

	world.entities.items[idx] = Entity{}
	world.entities.used[idx] = false
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
