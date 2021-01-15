<script>
  import "carbon-components-svelte/css/all.css";
  import { onMount } from "svelte";
  import axios from "axios";
  import {
    Search,
    Button,
    Grid,
    Row,
    Column,
    Select,
    SelectItem,
    MultiSelect,
  } from "carbon-components-svelte";
  import TaskTable from "./_TaskTable.svelte";
  import {
    updateModalOpen,
    tasks,
    searchPage,
    sortKey,
    sortOrder,
    labels,
  } from "models/tasks/store.js";
  import { LightPaginationNav } from "svelte-paginate";

  let searchName;
  let searchStatus = "";
  let searchLabelIds = [];
  export let fetchedTasks = [];
  let loading = false;
  const taskStatuses = {
    todo: "未着手",
    doing: "着手中",
    done: "完了",
  };
  let taskCount = 0;
  let pageSize = 10;

  function fetchTasks() {
    axios
      .get("/api/tasks/search", {
        params: {
          query: {
            name_cont: searchName,
            status_eq: searchStatus,
            labels_id_in: searchLabelIds,
            s: `${$sortKey} ${$sortOrder}`,
          },
          page: $searchPage,
        },
      })
      .then((res) => {
        taskCount = res.data.count;
        $tasks = res.data.tasks;
      })
      .catch((e) => alert(e))
      .finally(() => (loading = false));
  }

  function fetchLabels() {
    axios
      .get("/api/labels")
      .then((res) => {
        $labels = res.data.labels;
      })
      .catch((e) => alert(e));
  }

  function initFetchTasks() {
    fetchedTasks = [];
    $tasks = [];
    $searchPage = 1;
    loading = true;
    fetchTasks();
  }

  onMount(() => {
    fetchTasks();
    fetchLabels();
    $updateModalOpen = false;
  });

  const paginate = (e) => {
    $searchPage = e.detail.page;
    fetchTasks();
  };
</script>

<Grid padding>
  <Row>
    <Column>
      <Search placeholder="タスク名" bind:value={searchName} />
    </Column>
    <Column>
      <Select inline labelText="ステータス" bind:selected={searchStatus}>
        <SelectItem value="" text="全てのステータス" />
        {#each Object.entries(taskStatuses) as [key, value]}
          <SelectItem value={key} text={value} />
        {/each}
      </Select>
    </Column>
  </Row>
  <Row>
    <Column>
      <MultiSelect
        titleText="ラベル"
        label="ラベルを選択する"
        items={$labels.map((l) => ({ id: l.id, text: l.name }))}
        bind:selectedIds={searchLabelIds} />
    </Column>
    <Column>
      <Button on:click={initFetchTasks}>検索</Button>
    </Column>
  </Row>
</Grid>

<TaskTable {taskStatuses} {initFetchTasks} {fetchTasks} {fetchedTasks} />

{#if loading}
  <div>ロードしています。</div>
{:else if $tasks.length < 1}
  <div>検索結果が見つかりませんでした。</div>
{/if}

<LightPaginationNav
  totalItems={taskCount}
  {pageSize}
  currentPage={$searchPage}
  limit={1}
  showStepOptions={true}
  on:setPage={paginate} />
