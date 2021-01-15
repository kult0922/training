import TaskList from "pages/TaskList";
import JobsanHeader from "pages/shares/_JobsanHeader.svelte";
import TaskNew from "pages/TaskNew";
import UserNew from "pages/Admin/UserNew";
import UserList from "pages/Admin/UserList";

document.addEventListener("turbolinks:visit", () => {
  if (window.app) {
    window.app.$destroy();
    window.app = null;
  }
});

document.addEventListener("turbolinks:load", () => {
  let apps = [
    { elem: document.getElementById("task_list"), object: TaskList },
    { elem: document.getElementById("task_new"), object: TaskNew },
    { elem: document.getElementById("user_new"), object: UserNew },
    { elem: document.getElementById("user_list"), object: UserList },
    { elem: document.getElementById("jobsan_header"), object: JobsanHeader },
  ];
  let props = window.jsProps || {};

  apps.forEach((app) => {
    if (app.elem) {
      window.app = new app.object({ target: app.elem, props });
    }
  });
});
