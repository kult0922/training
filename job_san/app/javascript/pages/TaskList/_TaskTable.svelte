<script>
  import TaskEditModal from "./_TaskEditModal.svelte";
  import TaskTableRow from "./_TaskTableRow.svelte";
  import deepcopy from "deepcopy";

  import {
    updateModalOpen,
    tasks,
    searchPage,
    sortKey,
    sortOrder,
  } from "models/tasks/store.js";

  export let taskStatuses, fetchTasks;
  export let fetchedTasks = [];
  export let initFetchTasks = () => {};
  let selectedTask = {};

  function loadTasks() {
    $searchPage++;
    fetchTasks();
  }

  function sortTasksBy(_sortKey) {
    $sortKey = _sortKey;
    $sortOrder = $sortOrder === "desc" ? "asc" : "desc";
    initFetchTasks();
  }

  $: viewedSortedMark = (_sortKey) => {
    if ($sortKey === _sortKey) {
      return $sortOrder === "desc" ? "☝️" : "️👇";
    } else {
      return "";
    }
  };

  function openModal(_task) {
    $: selectedTask = _task;
    $updateModalOpen = true;
  }
</script>

<TaskEditModal
  {taskStatuses}
  selectedTask={deepcopy(selectedTask)}
  attachLabels={deepcopy(selectedTask.attach_labels)} />

<table style="width: 100%; border: solid;">
  <thead style="border: solid 1px">
    <tr>
      <th style="width: 40px">ID</th>
      <th style="width: 120px">タスク名</th>
      <th style="width: 100px">ステータス</th>
      <th style="width: 500px">ラベル</th>
      <th
        on:click={() => sortTasksBy('target_date')}
        style="cursor: pointer; background: wheat; width: 140px;"
        on:mouseover={(e) => {
          e.currentTarget.style.backgroundColor = 'burlywood';
        }}
        on:mouseout={(e) => {
          e.currentTarget.style.backgroundColor = 'wheat';
        }}>
        完了日{viewedSortedMark('target_date')}
      </th>
      <th
        on:click={() => sortTasksBy('created_at')}
        style="cursor: pointer; background: wheat; width: 140px;"
        on:mouseover={(e) => {
          e.currentTarget.style.backgroundColor = 'burlywood';
        }}
        on:mouseout={(e) => {
          e.currentTarget.style.backgroundColor = 'wheat';
        }}>
        作成日{viewedSortedMark('created_at')}
      </th>
      <th style="width: 10px;">🗑</th>
    </tr>
  </thead>
  <tbody>
    {#each $tasks as task}
      <TaskTableRow task={Object.assign({}, task)} {taskStatuses} {openModal} />
    {/each}
  </tbody>
</table>

<style>
  th {
    border: solid;
    padding: 10px;
  }
</style>
