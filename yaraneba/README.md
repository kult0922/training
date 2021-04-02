# yaraneba
TODO List

# Table of Contents
- [画面イメージ](#画面イメージ)
- [データ構造](#データ構造)

# 環境構築
ruby ver: 2.5.7
rails ver: 6.1.2.1
```
git clone git@github.com:Fablic/training.git && cd training
git checkout -b ブランチ名 リモートブランチ名
docker-compose -f docker/docker-compose.yml up -d
docker-compose -f docker/docker-compose.yml exec web rails db:migrate
docker-compose -f docker/docker-compose.yml exec web rails db:seed
# サーバ起動
docker-compose -f docker/docker-compose.yml exec web rails s -b 0.0.0.0
# テスト実行
docker-compose -f docker/docker-compose.yml exec web rails spec
# コンテナの停止
docker-compose -f docker/docker-compose.yml stop
# upで作成したコンテナ、ネットワーク、ボリューム、イメージを削除
docker-compose -f docker/docker-compose.yml down
```

# 画面イメージ
https://preview.studio.site/live/4Ra4k9voqD/[1~5]

# データ構造
## users
|カラム名|データ型|
|----|----|
|id|int|
|email|varchar|
|password|varchar|
|role_id|int|
|created_at|datetime|
|updated_at|datetime|
|deleted_at|datetime|

## roles
|カラム名|データ型|
|----|----|
|id|int|
|name|varchar|
|created_at|datetime|
|updated_at|datetime|
|deleted_at|datetime|

## labels
|カラム名|データ型|
|----|----|
|id|int|
|user_id|int|
|name|varchar|
|created_at|datetime|
|updated_at|datetime|
|deleted_at|datetime|

## tasks
|カラム名|データ型|
|----|----|
|id|int|
|user_id|int|
|title|varchar|
|detail|text|
|status|int|
|priority|int|
|end_date|datetime|
|created_at|datetime|
|updated_at|datetime|
|deleted_at|datetime|

## label_tasks
|カラム名|データ型|
|----|----|
|id|int|
|label_id|int|
|task_id|int|
|created_at|datetime|
|updated_at|datetime|
|deleted_at|datetime|
