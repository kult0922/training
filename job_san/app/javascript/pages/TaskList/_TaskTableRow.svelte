<script>
  import axios from "axios";
  // import moment from "moment";
  import { updateModalOpen, tasks } from "models/tasks/store.js";
  import { Tag } from "carbon-components-svelte";

  export let task, taskStatuses, openModal;

  const moment = require("moment").default || require("moment");

  const viewedTaskTargetDate = (_targetDate) =>
    !_targetDate ? "未設定" : moment(_targetDate).format("YYYY年MM月DD日");

  const viewedTaskCreatedAt = (_createdAt) =>
    moment(_createdAt).format("YYYY年MM月DD日");

  function viewedTaskName(_name) {
    return _name.length > 10 ? `${_name.substring(0, 9)}...` : _name;
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

<tr
  id={task.id}
  on:click={() => openModal(task)}
  on:mouseover={(e) => {
    e.currentTarget.style.backgroundColor = '#0f62fe';
    e.currentTarget.style.color = 'white';
  }}
  on:mouseout={(e) => {
    e.currentTarget.style.backgroundColor = 'white';
    e.currentTarget.style.color = 'black';
  }}
  style="cursor: pointer; border: solid;">
  <td>
    <div>{task.id}</div>
  </td>
  <td>
    <div>{viewedTaskName(task.name)}</div>
  </td>
  <td style="text-align: -webkit-center;">{taskStatuses[task.status]}</td>
  <td style="width: 500px;">
    {#each task.attach_labels as label, i}
      <!--        <Tag type="teal">{label.name}</Tag>-->
      <div
        style="float: left; padding: 10px; font-size: 10px; background: khaki; border-radius: 2em;">
        {label.name}
      </div>
    {/each}
  </td>
  <td style="text-align: -webkit-center;">
    {viewedTaskTargetDate(task.target_date)}
  </td>
  <td style="text-align: -webkit-center;">
    {viewedTaskCreatedAt(task.created_at)}
  </td>
  <td on:click={(e) => deleteTask(e, task)} style="text-align: -webkit-center;">
    ❌
  </td>
</tr>

<style>
  td {
    border-left: solid;
    padding: 10px;
  }
</style>
