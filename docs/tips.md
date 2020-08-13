# DB接続確認方法
```
rails db
```

# モデル作成方法
```
docker-compose exec web rails generate model task
```

# モデルを使ったレコード登録方法

```
docker-compose exec web rails c

new_task = Task.new
new_task.name = "hoge"
new_task.description = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
new_task.expire_date = "2020-08-13"
new_task.resiter_user_id = 0;
new_task.save

# 確認
Task.find(1)
  Task Load (0.7ms)  SELECT `tasks`.* FROM `tasks` WHERE `tasks`.`id` = 1 LIMIT 1
=> #<Task id: 1, name: "hoge", description: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa", status_code: 0, priority_code: 1, deleted_flag: false, expire_date: "2020-08-13", resiter_user_id: 0, created_at: "2020-08-13 04:46:50", updated_at: "2020-08-13 04:46:50">
```
