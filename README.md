# タスク管理システム（Task Manager）

## テーブルスキーマ

1.タスクテーブル

テーブル名：tasks
モデル名：Task

|カラム名|データ型|その他|
|:---|:---|:---|
|id|integer|primarykey,autoincrement|
|user_id|integer||
|title|varchar(100)||
|status|smallint||
|detail|text||
|end_date|timestamp||
|create_at|timestamp||

2.ユーザテーブル

テーブル名：users
モデル名：User

|カラム名|データ型|その他|
|:---|:---|:---|
|id|integer|primarykey,autoincrement|
|user_name|varchar(100)||
|password|varchar(100)||
|roll|smallint||
|create_at|timestamp||

3.ラベルテーブル

テーブル名：labels
モデル名：Label

|カラム名|データ型|その他|
|:---|:---|:---|
|id|integer|primarykey,autoincrement|
|task_id|integer||
|label|varchar(100)||
|create_at|timestamp||
