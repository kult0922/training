# About Displays

## ログイン画面
![image](docs/login.png)

* ユーザ名
* パスワード

を入力してログインする。  
入力された内容に問題があれば、flashでエラーメッセージを表示する。  

パスワード忘れたリンクが入ってるが、無視で！

## タスク一覧画面
![image](docs/tasks.png)

登録されているタスクを表示する画面。  
ログイン済みじゃないと表示できない。  

以下のリンクを設置する。  

* ユーザ作成リンク
  * ユーザ作成画面に遷移する
* ユーザ管理リンク
  * ユーザ一覧画面に遷移する
  * ログインしているユーザの権限が `管理者` の場合のみリンクを表示する
* ログアウトリンク
  * ログアウトし、ログイン画面に遷移する

以下の検索機能を用意する。

* タスク名・詳細のワード検索
* タスクのステータスの検索
* タスク登録ユーザの検索

これらをAND検索で検索する。  

また、タスクの一覧画面を用意する。  
表示する項目は以下の通り。

* タスク名
* ステータス
* 優先度
  * カラム名をクリックするとこのカラムをもとにSortされる
* 期限
  * カラム名をクリックするとこのカラムをもとにSortされる
* ラベル
  * 複数あれば複数表示する
* 登録ユーザ名
* 編集リンク
  * タスク編集画面に遷移する
* 削除リンク
  * 削除確認ダイアログが出て、OKを押したら削除をし画面リロード
  * キャンセルを押したらダイアログが閉じるのみ

初期表示時、一覧は期限の昇順で並び替えをする。

## タスク作成画面
![image](docs/create_task.png)

タスクを新規作成する画面。

以下の項目を表示する。

* タスク名
  * 必須入力
  * 50文字まで
* タスク詳細
  * 1000文字まで
* ステータス
  * 必須選択
  * プルダウン選択
  * 以下から選択する
    * todo
    * doing
    * pending
    * done
  * デフォルトはtodo
* 優先度
  * 必須選択
  * プルダウン選択
  * 以下から選択する
    * low
    * middle
    * high
  * デフォルトはmiddle
* 期限
  * 必須入力
  * 年・月・日を入力
* ラベル
  * 一つのワードにつき10文字まで
  * 複数入力可

作成ボタンをクリックするとタスクが作成され、タスク一覧画面に遷移する。  
入力内容に問題があれば、flashにエラー内容を表示する。  
その際に入力内容は保持する。

## タスク編集画面
タスク作成画面と同様。  
指定されたタスクの内容を各項目にデフォルトでセットしておく。  

自分が作成したタスクのみ編集可能。  

## ユーザ作成画面
![image](docs/create_user.png)

ユーザ作成画面。  
管理者のみアクセス可能。

以下の項目を表示する。

* ユーザ名
  * 必須入力
  * 20文字まで
  * 半角英数字のみ
* パスワード
  * 必須入力
  * ポリシーはRails標準に則る
* パスワード(確認用)
  * 必須入力
* 権限
  * 必須選択
  * 以下の中から選択する
    * 一般
    * 管理者

作成ボタンをクリックしたらユーザを作成し、ユーザ一覧画面に遷移する。  
入力内容に問題があればFlashでエラーメッセージを表示する。  
その際は入力内容を保持する。

## ユーザ編集画面
ユーザ作成画面と同様。  
指定されたユーザの内容を各項目にデフォルトでセットしておく。  

## ユーザ一覧画面
![image](docs/users.png)

ユーザ一覧画面。  
ログインしているユーザの権限が管理者の場合のみこの画面にアクセス可能。

以下の一覧を表示する。

* ユーザ名
* 権限
* 編集リンク
  * リンクをクリックするとユーザ編集画面に遷移する
* 削除リンク
  * 削除確認ダイアログが出て、OKを押したら削除をし画面リロード
  * キャンセルを押したらダイアログが閉じるのみ

# Table Definition
## tasks
物理名 | 論理名 | 型 | サイズ | NN | PK | Comment
--- | --- | --- | --- | --- | --- | ---
id | id | biginteger |  | yes | yes | 
name | 名前 | varchar | 20 | yes |  | 
description | 詳細 | text |  | yes |  | 
status_code | ステータス | tinyint |  |  |  | 0: todo, 1: doing, 2: pending, 3: done
priority_code | 優先度 | tinyint |  |  |  | 0: low, 1: middle, 2: high
expire_date | 有効期限 | DATE |  | yes |  | 
register_uesr_id | ユーザID | biginteger |  | yes |  | 
deleted_flag | 削除フラグ | tinyint |  | yes |  | 0: 未削除, 1: 削除済み
created_at | 作成日 | DATETIME |  | yes |  | 
updated_at | 更新日 | DATETIME |  | yes |  | 

* 外部キー
  * register_user_id
    * -> users
* Index
  * idx_tasks_id_deleted_flag
    * id, deleted_flag
  * idx_tasks_list
    * name, description, status_code, priority_code, expire_date, deleted_flag

## task_labels
物理名 | 論理名 | 型 | サイズ | NN | PK | Comment
--- | --- | --- | --- | --- | --- | ---
id | id | biginteger |  | yes | yes | 
task_id | タスクID | varchar | 20 | yes |  | 
name | ラベル名 | varchar | 10 | yes |  | 
created_at | 作成日 | DATETIME |  | yes |  | 
updated_at | 更新日 | DATETIME |  | yes |  | 

* 外部キー
  * tasks_id
    * -> tasks

## users
物理名 | 論理名 | 型 | サイズ | NN | PK | Comment
--- | --- | --- | --- | --- | --- | ---
id | id | biginteger |  | yes | yes | 
name | ユーザ名 | varchar | 20 | yes |  | 
password | パスワード | varchar | 32 | yes |  | 
role | 権限 | tinyint |  | yes |  | 0: 管理者, 1: 一般
deleted_flag | 削除フラグ | tinyint |  | yes |  | 0: 未削除, 1: 削除済み
created_at | 作成日 | DATETIME |  | yes |  | 
updated_at | 更新日 | DATETIME |  | yes |  | 

* Index
  * idx_users_id_deleted_flag
    * id, deleted_flag
  * idx_users_exists
    * name, password, deleted_flag
