<script>
  import axios from "axios";

  import deepcopy from "deepcopy";
  import {
    ComposedModal,
    ModalHeader,
    ModalBody,
    ModalFooter,
    TextInput,
    Select,
    SelectItem,
  } from "carbon-components-svelte";
  import LabelCheckbox from "./_LabelCheckbox.svelte";
  import { updateModalOpen, tasks, labels } from "models/tasks/store.js";

  export let taskStatuses = {};
  export let selectedTask = {};
  let updateModalChecked = true;
  let validationError = "";
  export let attachLabels = [];

  const updateTask = () => {
    axios
      .put(`/api/tasks/${selectedTask.id}`, {
        task: {
          name: selectedTask.name,
          description: selectedTask.description,
          target_date: selectedTask.target_date,
          status: selectedTask.status,
          attach_labels: attachLabels.map((l) => l.id),
        },
      })
      .then((res) => {
        const updatedTaskIndex = $tasks.findIndex(
          (t) => t.id === selectedTask.id
        );
        if (updatedTaskIndex > -1) {
          selectedTask.attach_labels = attachLabels;
          $tasks[updatedTaskIndex] = selectedTask;
        }
        alert(res.data.message);
      })
      .catch((e) => {
        alert(e.data.message);
      })
      .finally(() => ($updateModalOpen = false));
  };

  const validateUpdateTask = () => {
    if (selectedTask.name < 1 || selectedTask.name > 255) {
      updateModalChecked = false;
      validationError = "タスク名は１文字以上２５５文字以下に設定してください";
    } else if (selectedTask.description > 255) {
      updateModalChecked = false;
      validationError = "説明文は２５５文字以下に設定してください";
    } else {
      updateModalChecked = true;
      validationError = "";
    }
  };

  const onClickLabelCheckbox = (label) => {
    attachLabels = Object.assign([], attachLabels);
    const matchedIndex = attachLabels.findIndex((l) => l.id === label.id);
    matchedIndex > -1
      ? attachLabels.splice(matchedIndex, 1)
      : attachLabels.push(label);
  };

  const onClose = () => {
    validationError = "";
    $updateModalOpen = false;
  };
</script>

<ComposedModal
  open={$updateModalOpen}
  on:submit={updateTask}
  on:close={onClose}>
  <ModalHeader title="タスクの詳細" />
  <ModalBody hasForm>
    <p>ID: {selectedTask.id}</p>
    <TextInput
      labelText="タスク名"
      placeholder="サンプルタスク"
      bind:value={selectedTask.name}
      on:change={validateUpdateTask} />
    <TextInput
      labelText="説明文"
      placeholder="サンプル説明文"
      bind:value={selectedTask.description}
      on:change={validateUpdateTask} />
    <label>
      完了日：<input type="date" bind:value={selectedTask.target_date} />
    </label>
    <Select inline labelText="ステータス" bind:selected={selectedTask.status}>
      {#each Object.entries(taskStatuses) as [key, value]}
        <SelectItem value={key} text={value} />
      {/each}
    </Select>
    {#each $labels as label}
      <LabelCheckbox
        {label}
        attachLabels={deepcopy(attachLabels)}
        {onClickLabelCheckbox} />
    {/each}

    <p style="color: red;">{validationError}</p>
  </ModalBody>
  <ModalFooter
    primaryButtonText="保存"
    primaryButtonDisabled={!updateModalChecked} />
</ComposedModal>
