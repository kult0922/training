<script>
  import axios from "axios";
  import {
    ComposedModal,
    ModalHeader,
    ModalBody,
    ModalFooter,
    TextInput,
    Select,
    SelectItem,
  } from "carbon-components-svelte";
  import { updateModalOpen, tasks } from "models/tasks/store.js";

  const userRoleTypes = {
    member: "メンバー",
    admin: "管理者",
  };
  export let selectedTask = {};
  let userRoleType = "member";
  let updateModalChecked = true;
  let validationError = "";

  const updateTask = () => {
    axios
      .put(`/api/tasks/${selectedTask.id}`, {
        task: selectedTask,
      })
      .then((res) => {
        const updatedTaskIndex = $tasks.findIndex(
          (t) => t.id === selectedTask.id
        );
        if (updatedTaskIndex > -1) {
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
      validationError = "ユーザ名は１文字以上２５５文字以下に設定してください";
    } else if (selectedTask.description > 255) {
      updateModalChecked = false;
      validationError = "アドレスは２５５文字以下に設定してください";
    } else {
      updateModalChecked = true;
      validationError = "";
    }
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
  <ModalHeader title="ユーザの詳細" />
  <ModalBody hasForm>
    <p>ID: {selectedTask.id}</p>
    <TextInput
      labelText="ユーザ名"
      placeholder="ユーザ名を入力してください"
      bind:value={selectedTask.name}
      on:change={validateUpdateTask} />
    <TextInput
      labelText="アドレス"
      placeholder="アドレスを入力してください"
      bind:value={selectedTask.description}
      on:change={validateUpdateTask} />
    <Select inline labelText="ロール" bind:selected={userRoleType}>
      {#each Object.entries(userRoleTypes) as [key, value]}
        <SelectItem value={key} text={value} />
      {/each}
    </Select>

    <p style="color: red;">{validationError}</p>
  </ModalBody>
  <ModalFooter
    primaryButtonText="保存"
    primaryButtonDisabled={!updateModalChecked} />
</ComposedModal>
