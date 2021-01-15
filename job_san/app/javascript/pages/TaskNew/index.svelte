<script>
  import axios from "axios";
  import {
    TextInput,
    Checkbox,
    Select,
    SelectItem,
  } from "carbon-components-svelte";
  import { onMount } from "svelte";

  function fetchLabels() {
    axios
      .get("/api/labels")
      .then((res) => {
        labels = res.data.labels;
      })
      .catch((e) => alert(e));
  }

  let labels = [];
  let selectedLabelId = [];
  let inputTargetDate = false;
  let targetDate = null;
  let validationError = " ";
  let description = "";
  let taskName = "";
  let taskStatus = "todo";
  const taskStatuses = {
    todo: "未着手",
    doing: "着手中",
    done: "完了",
  };

  const createTask = () => {
    axios
      .post("/api/tasks", {
        task: {
          name: taskName,
          description: description,
          target_date: targetDate,
          status: taskStatus,
          attach_labels: selectedLabelId,
        },
      })
      .then(() => {
        alert("タスクを作成しました");
        location.href = "/tasks";
      })
      .catch((e) => alert(e));
  };

  const validateCreateTask = () => {
    if (taskName < 1 || taskName > 255) {
      validationError = "タスク名は１文字以上２５５文字以内にしてください";
    } else if (description > 255) {
      validationError = "説明文は１文字以上２５５文字以内にしてください";
    } else {
      validationError = "";
    }
  };

  const onClickLabelCheckbox = (label) => {
    console.log(label);
    console.log(selectedLabelId);
    const matchedIndex = selectedLabelId.findIndex((id) => id === label.id);
    console.log(matchedIndex);
    matchedIndex > -1
      ? selectedLabelId.splice(matchedIndex, 1)
      : selectedLabelId.push(label.id);
  };

  onMount(() => {
    fetchLabels();
  });
</script>

<div style="width: 100%">
  <div style="width: 640px;margin: auto;">
    <TextInput
      labelText="タスク名"
      placeholder="タスク名を入力してください"
      bind:value={taskName}
      on:change={validateCreateTask} />
    <TextInput
      labelText="説明文"
      placeholder="説明文を入力してください"
      bind:value={description}
      on:change={validateCreateTask} />
  </div>
  <div style="width: 640px;margin: auto;">
    <div style="margin: 20px 0px; width: 200px">
      <Select labelText="ステータス" bind:selected={taskStatus}>
        <SelectItem value="" text="全てのステータス" />
        {#each Object.entries(taskStatuses) as [key, value]}
          <SelectItem value={key} text={value} />
        {/each}
      </Select>
    </div>

    <Checkbox labelText="完了日を入力" bind:checked={inputTargetDate} />
    {#if inputTargetDate}
      <label for="target_date">完了日:</label>
      <input id="target_date" type="date" bind:value={targetDate} />
    {/if}
  </div>
  <div style="border: solid; padding: 10px 20px;">
    <p>付与するラベルを選択</p>
    <div>
      {#each labels as label}
        <label>
          <input type="checkbox" on:click={() => onClickLabelCheckbox(label)} />
          {label.name}
        </label>
      {/each}
    </div>
  </div>
  <div style="text-align-last: center;">
    <p style="color: red">{validationError}</p>
    {#if validationError.length < 1}
      <button on:click={createTask} style="padding: 20px">作成</button>
    {:else}<button disabled style="padding: 10px 40px">作成</button>{/if}
  </div>
</div>
