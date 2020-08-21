// タスク登録・編集画面内の日付の入力制限

var today = new Date();

var select_year = document.getElementById('task_deadline_1i');
var select_month = document.getElementById('task_deadline_2i');
var select_day = document.getElementById('task_deadline_3i');
var select_hours = document.getElementById('task_deadline_4i');
var select_minutes = document.getElementById('task_deadline_5i');

var select_date = new Date(`${select_year.value}`, `${select_month.value - 1}`,
`${select_day.value}`, `${select_hours.value}`, `${select_minutes.value}`);

function set_datetime(year, month, day, hours, minutes){
  return new Date(`${year}`, `${month - 1}`, `${day}`, `${hours}`, `${minutes}`);
}

select_year.onchange = function(){
  select_date = set_datetime(select_year.value, select_month.value, select_day.value, select_hours.value, select_minutes.value);

  if(select_date < today){
    select_year.value = today.getFullYear();
    select_date = set_datetime(select_year.value, select_month.value, select_day.value, select_hours.value, select_minutes.value);
    alert("過去の年は入力できません。");
  }
}

select_month.onchange = function(){
  select_date = set_datetime(select_year.value, select_month.value, select_day.value, select_hours.value, select_minutes.value);
  if(select_date < today){
    select_month.value = today.getMonth() + 1;
    select_date = set_datetime(select_year.value, select_month.value, select_day.value, select_hours.value, select_minutes.value);
    alert("過去の月は入力できません。");
  }
}

select_day.onchange = function(){
  select_date = set_datetime(select_year.value, select_month.value, select_day.value, select_hours.value, select_minutes.value);

  if(select_date < today){
    select_day.value = today.getDate();
    select_date = set_datetime(select_year.value, select_month.value, select_day.value, select_hours.value, select_minutes.value);
    alert("過去の日にちは入力できません。");
  }
}

select_hours.onchange = function(){
  select_date = set_datetime(select_year.value, select_month.value, select_day.value, select_hours.value, select_minutes.value);

  if(select_date < today){
    select_hours.value = today.getHours();
    select_date = set_datetime(select_year.value, select_month.value, select_day.value, select_hours.value, select_minutes.value);
    alert("過去の時間は入力できません。");
  }
}

select_minutes.onchange = function(){
  select_date = set_datetime(select_year.value, select_month.value, select_day.value, select_hours.value, select_minutes.value);
  
  if(select_date < today){
    select_minutes.value = today.getMinutes();
    select_date = set_datetime(select_year.value, select_month.value, select_day.value, select_hours.value, select_minutes.value);
    alert("過去の分は入力できません。");
  }
}
