# README

## テーブルスキーマ

①ユーザー (User / users)
--------
項目名 | column  | type  | null | default | key |  uniq | extra | describe
--- | --- | --- | --- | ---  | ---  | ---  | --- | --- 
ID | id | bigint | false | - | ○ | ○ | auto_increment |
メールアドレス | email | varchar(255) | false | - | - | ○ | 
パスワード | password | varchar(255) | false | - | - | - | 
作成日 | created_at | datetime | false | - | - | - | 
更新日 | updated_at | datetime | false | - | - | - | 

②タスク (Task / tasks)
--------
項目名 | column  | type  | null | default | key | uniq | extra | describe
--- | --- | --- | --- | ---  | ---  | ---  | --- | --- 
ID | id | bigint | false | - | ○ | ○ | auto_increment |
ユーザーID | user_id | int | false | - | ○ | - |
名前 | title | varchar(255) | false | - | - | - | 
説明 | description | text | false | - | - | - | 
優先度 | priority | int | false | - | - | - | - |※ enum <br> 1: 'low' <br> 2: 'medium' <br> 3: 'high' <br> 4: 'cretical' 
ステータス | status | int | false | - | - | - | - |※ enum <br> 1: 'waiting' <br> 2: 'work_in_progress' <br> 3: 'completed'
作成日 | created_at | datetime | false | - | - | - | 
更新日 | updated_at | datetime | false | - | - | - | 

③ラベル (Label / labels)
--------
項目名 | column  | type  | null | default | key |  uniq | extra | describe
--- | --- | --- | --- | ---  | ---  | ---  | --- | --- 
ID | id | bigint | false | - | ○ | ○ | auto_increment |
名前 | name | varchar(255) | false | - | - | - | 
作成日 | created_at | datetime | false | - | - | - | 
更新日 | updated_at | datetime | false | - | - | - | 

④タスクラベル (TaskLabel / task_labels)
--------
項目名 | column  | type  | null | default | key |  uniq | extra | describe
--- | --- | --- | --- | ---  | ---  | ---  | --- | --- 
ID | id | bigint | false | - | ○ | ○ | auto_increment |
タスクID | task_id | int | false | - | ○ | - |
ラベルID | label_id | int | false | - | ○ | - |
作成日 | created_at | datetime | false | - | - | - | 
更新日 | updated_at | datetime | false | - | - | - | 