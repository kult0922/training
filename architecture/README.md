# data schema

![タスク一覧画面](タスク一覧画面.png "taskview")
![E-R図](e-r.png "e-r")

## タスクテーブル
```
{
  id: int (not null unique),
  name: char(30) (not null),
  end_date: date,
  priority: int,
  description: char(300),
}
```

## ラベルテーブル
```
{
  id: int (not null unique),
  name: char(10) (not null),
}
```

## タスク-ラベルテーブル(中間テーブル)
```
{
  id: int (not null unique),
  task_id: int (not null),
  lebel_id: int (not null),
}
```
