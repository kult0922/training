<script>
  import axios from "axios";
  import { onMount } from "svelte";
  import {
    TextInput,
    Select,
    SelectItem,
    PasswordInput,
  } from "carbon-components-svelte";

  let email = "";
  let userName = "";
  let password = "";
  let passwordConfirmation = "";
  let emailError = "";
  let userNameError = "";
  let passwordError = "";
  let passwordConfirmationError = "";
  let roleType = "member";
  const userRoleTypes = {
    member: "メンバー",
    admin: "管理者",
  };

  const createUser = () => {
    axios
      .post("/api/users", {
        task: {
          name: userName,
          email: email,
          password: password,
          passwordConfirmation: passwordConfirmation,
          roleType: roleType,
        },
      })
      .then(() => {
        alert("ユーザを作成しました");
        location.href = "/admin/users";
      })
      .catch((e) => alert(e));
  };

  const validateCreateUser = () => {
    [userNameError, emailError, passwordError, passwordConfirmationError] = [
      "",
      "",
      "",
      "",
    ];
    if (userName < 1 || userName > 255) {
      userNameError = "ユーザ名は１文字以上２５５文字以内にしてください";
    }
    if (!email.includes("@")) {
      emailError = "アドレスの形式が異なります";
    }
    if (email > 255 || email < 1) {
      emailError = "アドレスは１文字以上２５５文字以内にしてください";
    }
    if (password > 255 || password < 1) {
      passwordError = "パスワードは１文字以上２５５文字以内にしてください";
    }
    if (password !== passwordConfirmation) {
      passwordConfirmationError = "パスワードが一致しません";
    }
  };
  $: isValidationError =
    [
      userNameError,
      emailError,
      passwordError,
      passwordConfirmationError,
    ].filter((i) => !!i).length < 1;

  onMount(() => {
    isValidationError = false;
  });
</script>

<div style="width: 100%">
  <div style="width: 640px;margin: auto;">
    <TextInput
      labelText="ユーザ名"
      placeholder="ユーザ名を入力してください"
      invalid={!!userNameError}
      invalidText={userNameError}
      bind:value={userName}
      on:change={validateCreateUser} />
    <TextInput
      labelText="アドレス"
      placeholder="アドレスを入力してください"
      invalid={!!emailError}
      invalidText={emailError}
      bind:value={email}
      on:change={validateCreateUser} />
    <PasswordInput
      labelText="パスワード"
      placeholder="パスワードを入力してください"
      invalid={!!passwordError}
      invalidText={passwordError}
      bind:value={password}
      on:change={validateCreateUser} />
    <PasswordInput
      labelText="パスワード確認"
      placeholder="パスワードを入力してください"
      invalid={!!passwordConfirmationError}
      invalidText={passwordConfirmationError}
      bind:value={passwordConfirmation}
      on:change={validateCreateUser} />
    <Select labelText="ロール" bind:selected={roleType}>
      {#each Object.entries(userRoleTypes) as [key, value]}
        <SelectItem value={key} text={value} />
      {/each}
    </Select>
  </div>
  <div style="text-align-last: center;">
    {#if isValidationError}
      <button on:click={createUser} style="padding: 20px">作成</button>
    {:else}<button disabled style="padding: 10px 40px">作成</button>{/if}
  </div>
</div>
