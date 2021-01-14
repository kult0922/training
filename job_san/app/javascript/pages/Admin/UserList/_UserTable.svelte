<script>
  import axios from "axios";
  import { updateModalOpen, tasks } from "models/tasks/store.js";
  import UserEditModal from "./_UserEditModal.svelte";

  export let initFetchUsers, fetchedUsers;
  let selectedTask = {};

  function openModal(_task) {
    selectedTask = Object.assign({}, _task);
    $updateModalOpen = true;
  }

  const deleteTask = (event, _task) => {
    event.stopPropagation();
    if (confirm(`${_task.name}を削除しますか？`)) {
      axios
        .delete(`/api/tasks/${_task.id}`)
        .then((res) => {
          const deletedTaskIndex = $tasks.findIndex((t) => t.id === _task.id);
          if (deletedTaskIndex > -1) {
            $tasks[deletedTaskIndex] = null;
            $tasks = $tasks.filter((t) => t);
          }
          alert(res.data.message);
        })
        .catch((e) => {
          alert(e.data.message);
        });
    }
    $updateModalOpen = false;
  };
</script>

<UserEditModal {selectedTask} />

<table style="width: 100%; border: solid;">
  <thead style="border: solid 1px">
    <tr>
      <th>ID</th>
      <th>ユーザ名</th>
      <th>アドレス</th>
      <th>タスクの所持数</th>
      <th>🗑</th>
    </tr>
  </thead>
  <tbody>
    {#each $tasks as _task}
      <tr
        id={_task.id}
        on:click={() => openModal(_task)}
        on:mouseover={(e) => {
          e.currentTarget.style.backgroundColor = '#0f62fe';
          e.currentTarget.style.color = 'white';
        }}
        on:mouseout={(e) => {
          e.currentTarget.style.backgroundColor = 'white';
          e.currentTarget.style.color = 'black';
        }}
        style="cursor: pointer;">
        <td>{_task.id}</td>
        <td>{_task.name}</td>
        <td>{_task.name}</td>
        <td style="text-align: -webkit-center;">{_task.name.length}</td>
        <td
          on:click={(e) => deleteTask(e, _task)}
          style="text-align: -webkit-center;">
          ❌
        </td>
      </tr>
    {/each}
  </tbody>
</table>

<style>
  th {
    border: solid;
    padding: 10px;
  }
  td {
    border-left: solid;
    padding: 10px;
  }
</style>
