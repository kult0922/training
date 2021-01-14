<script>
  import "carbon-components-svelte/css/all.css";
  import { onMount } from "svelte";
  import axios from "axios";
  import { Search, Button } from "carbon-components-svelte";
  import UserTable from "./_UserTable.svelte";
  import { updateModalOpen, tasks, searchPage } from "models/tasks/store.js";

  let searchName;
  export let fetchedUsers = [];
  let loading = false;

  function fetchUsers() {
    axios
      .get("/api/tasks/search", {
        params: {
          query: {
            name_cont: searchName,
          },
          page: $searchPage,
        },
      })
      .then((res) => {
        fetchedUsers = res.data;
        $tasks = [...$tasks, ...fetchedUsers];
      })
      .catch((e) => alert(e))
      .finally(() => (loading = false));
  }

  function initFetchUsers() {
    fetchedUsers = [];
    $tasks = [];
    $searchPage = 1;
    loading = true;
    fetchUsers();
  }

  onMount(() => {
    fetchUsers();
    $updateModalOpen = false;
  });
</script>

<div style="display: -webkit-inline-box; margin: 20px 0px;">
  <Search
    placeholder="ユーザ名"
    bind:value={searchName}
    style="margin-right: 40px; width: 400px" />
  <Button on:click={initFetchUsers}>検索</Button>
</div>

<UserTable {initFetchUsers} {fetchUsers} {fetchedUsers} />

{#if loading}
  <div>ロードしています。</div>
{:else if $tasks.length < 1}
  <div>検索結果が見つかりませんでした。</div>
{/if}
