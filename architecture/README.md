# data schema

## タスクテーブル
```json
{
  id: int (not null),
  name: char (not null),
  end_date: date,
  priority: int,
  description: char,
}
```

## ラベルテーブル
```json
{
  id: int (not null),
  name: char (not null),
}
```

## タスク-ラベルテーブル(中間テーブル)
```json
{
  id: int (not null),
  task_id: int (not null),
  lebel_id: int (not null),
}
```
