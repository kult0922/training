import TaskList from 'pages/TaskList';
import JobsanHeader from 'pages/shares/_JobsanHeader.svelte';
import TaskNew from 'pages/TaskNew';

document.addEventListener('turbolinks:visit', () => {
  if(window.app) {
    window.app.$destroy();
    window.app = null;
  }
});

document.addEventListener('turbolinks:load', () => {
  let apps = [{ elem: document.getElementById("task_list"), object: TaskList },
      { elem: document.getElementById("task_new"), object: TaskNew },
      { elem: document.getElementById("jobsan_header"), object: JobsanHeader }];
  let props = window.jsProps || {}

  apps.forEach(app => {
      if(app.elem){
          window.app = new app.object({ target: app.elem, props });
      }
    });
});
