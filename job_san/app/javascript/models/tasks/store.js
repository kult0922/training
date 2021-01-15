import { writable } from 'svelte/store';

export const updateModalOpen = writable(false);
export const tasks = writable([]);
export const searchPage = writable(1);
export const sortKey = writable("created_at");
export const sortOrder = writable("desc");
export const labels = writable([]);
