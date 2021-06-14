# README

## ペーパープロトタイピング

### 画面設計

![PXL_20210611_061009202](https://user-images.githubusercontent.com/85146460/121640279-af678880-cac8-11eb-95f5-55deba179cd2.jpg)
![PXL_20210611_061014064](https://user-images.githubusercontent.com/85146460/121640302-b393a600-cac8-11eb-9ee4-bc5a2666d626.jpg)

## モデル設計

![image](https://user-images.githubusercontent.com/85146460/121843649-a28fa280-cd1d-11eb-95d9-eaea1972f9b9.png)

### tasks タスク

|  Column  |  Type  | Default  |  Description  |
| ---- | ---- | ---- | ---- |
|  id  |  integer  | auto_increment | プライマリーキー |
|  name  |  varchar(255)  | not null  | タスク名, 検索対象 |
|  description  |  text  | null | タスク説明 |
|  task_status_id  |  integer  | not null | ステータスリレーションカラム |
|  task_level_id  |  integer  | null | 優先度リレーションカラム |
|  task_label_id  |  integer | null  | ラベルリレーションカラム |
|  user_id  |  integer | null  | ユーザリレーションカラム |
|  end_at  |  datetime  | null  | 終了期限 |
|  created_at  |  datetime | default now() | 作成日時 |
|  updated_at  |  datetime | default updated now() | 更新日時 |
|  deleted_at  |  datetime  | null  | 削除日時 |

### task_status ステータス

|  Column  |  Type  | Default  |  Description  |
| ---- | ---- | ---- | ---- |
|  id  |  integer  | not null | プライマリーキー |
|  name  |  varchar(10)  | not null | ステータス名 |
|  priority  |  integer  | not null | 表示順 |

> 未着手・着手・完了の固定の値が入る予定

### tasks_level 優先度

|  Column  |  Type  | Default  |  Description  |
| ---- | ---- | ---- | ---- |
|  id  |  integer  | not null | プライマリーキー |
|  name  |  varchar(10)  | not null | 優先度名 |
|  priority  |  integer  | not null | 表示順 |

> High・Middle・Lowの固定の値が入る予定

### tasks_label タスクラベル（多対多リレーション）

|  Column  |  Type  | Default  |  Description  |
| ---- | ---- | ---- | ---- |
|  id  |  integer  | auto_increment | プライマリーキー |
|  task_id  |  integer  | not null | タスクリレーションカラム |
|  label_id  |  integer  | not null | ラベルリレーションカラム |
|  created_at  |  datetime | default now() | 作成日時 |

> unique制約 taskId, labelId

### labels ラベル

|  Column  |  Type  | Default  |  Description  |
| ---- | ---- | ---- | ---- |
|  id  |  integer  | auto_increment | プライマリーキー |
|  name  |  varchar(50)  | not null | ラベル名 |
|  color  |  enum(red, yellow, green,...)  | null | カラー |
|  created_at  |  datetime | default now() | 作成日時 |

> unique制約 name

### users ユーザ

|  Column  |  Type  | Default  |  Description  |
| ---- | ---- | ---- | ---- |
|  id  |  integer  | auto_increment | プライマリーキー |
|  username  |  varchar(20)  | not null | ユーザ名 |
|  icon  |  varchar(255)  | null | アイコン画像URL |
|  role  |  enum(normal, maintainer)  | default normal | 権限 |
|  created_at  |  datetime | default now() | 作成日時 |
|  updated_at  |  datetime | default updated now() | 更新日時 |
|  deleted_at  |  datetime  | null  | 削除日時 |

> unique制約 username

### users_secrets ユーザ秘匿情報

|  Column  |  Type  | Default  |  Description  |
| ---- | ---- | ---- | ---- |
|  user_id  |  integer  | not null | ユーザリレーションカラム, プライマリーキー |
|  email  |  varchar(255)  | not null | メールアドレス |
|  password_hash  |  varchar(255)  | not null | パスワード |
