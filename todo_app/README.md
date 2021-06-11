# README

## ペーパープロトタイピング

### 画面設計

![PXL_20210611_061009202](https://user-images.githubusercontent.com/85146460/121640279-af678880-cac8-11eb-95f5-55deba179cd2.jpg)
![PXL_20210611_061014064](https://user-images.githubusercontent.com/85146460/121640302-b393a600-cac8-11eb-9ee4-bc5a2666d626.jpg)

## モデル設計

![PXL_20210611_061021491](https://user-images.githubusercontent.com/85146460/121640307-b55d6980-cac8-11eb-8510-9d6a7e848946.jpg)

### Task タスク

|  Column  |  Type  | Default  |  Description  |
| ---- | ---- | ---- | ---- |
|  id  |  integer  | auto_increment | プライマリーキー |
|  name  |  varchar(255)  | not null  | タスク名 |
|  description  |  varchar(1000)  | null | タスク説明 |
|  taskStatusId  |  integer  | not null | ステータスリレーションカラム |
|  taskLevelId  |  integer  | null | 優先度リレーションカラム |
|  taskLabelId  |  integer | null  | ラベルリレーションカラム |
|  userId  |  integer | null  | ユーザリレーションカラム |
|  endAt  |  datetime  | null  | 終了期限 |
|  createdAt  |  datetime | default now() | 作成日時 |
|  updatedAt  |  datetime | default updated now() | 更新日時 |
|  deletedAt  |  datetime  | null  | 削除日時 |

### TaskStatus ステータス

|  Column  |  Type  | Default  |  Description  |
| ---- | ---- | ---- | ---- |
|  id  |  integer  | not null | プライマリーキー |
|  name  |  varchar(10)  | not null | ステータス名 |
|  sort  |  integer  | not null | ソート順 |

> 未着手・着手・完了の固定の値が入る予定

### TaskLevel 優先度

|  Column  |  Type  | Default  |  Description  |
| ---- | ---- | ---- | ---- |
|  id  |  integer  | not null | プライマリーキー |
|  name  |  varchar(10)  | not null | 優先度名 |
|  sort  |  integer  | not null | ソート順 |

> High・Middle・Lowの固定の値が入る予定

### TaskLabel タスクラベル（多対多リレーション）

|  Column  |  Type  | Default  |  Description  |
| ---- | ---- | ---- | ---- |
|  id  |  integer  | auto_increment | プライマリーキー |
|  taskId  |  integer  | not null | タスクリレーションカラム |
|  labelId  |  integer  | not null | ラベルリレーションカラム |
|  createdAt  |  datetime | default now() | 作成日時 |

> unique制約 taskId, labelId

### Label ラベル

|  Column  |  Type  | Default  |  Description  |
| ---- | ---- | ---- | ---- |
|  id  |  integer  | auto_increment | プライマリーキー |
|  name  |  varchar(50)  | not null | ラベル名 |
|  color  |  enum(red, yellow, green,...)  | null | カラー |
|  createdAt  |  datetime | default now() | 作成日時 |

> unique制約 name

### User ユーザ

|  Column  |  Type  | Default  |  Description  |
| ---- | ---- | ---- | ---- |
|  id  |  varchar(16)  | uuid() | プライマリーキー |
|  username  |  varchar(20)  | not null | ユーザ名 |
|  icon  |  varchar(255)  | null | アイコンURL |
|  role  |  enum(normal, maintainer)  | default normal | 権限 |
|  createdAt  |  datetime | default now() | 作成日時 |
|  updatedAt  |  datetime | default updated now() | 更新日時 |
|  deletedAt  |  datetime  | null  | 削除日時 |

> unique制約 username

### UserSecret ユーザ秘匿情報

|  Column  |  Type  | Default  |  Description  |
| ---- | ---- | ---- | ---- |
|  userId  |  varchar(16)  | uuid() | ユーザリレーションカラム, プライマリーキー |
|  email  |  varchar(255)  | not null | メールアドレス |
|  passwordHash  |  text  | not null | パスワード |
