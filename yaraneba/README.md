# yaraneba
TODO List

# Table of Contents
- [画面イメージ](#画面イメージ)
- [データ構造](#データ構造)

# 画面イメージ 
https://preview.studio.site/live/4Ra4k9voqD/[1~5]

# データ構造 
## user
|カラム名|データ型|
|----|----|
|id|int|
|email|varchar|
|password|varchar|
|role_id|tinyint|
|created_at|datetime|
|updated_at|datetime|
|deleted_at|datetime|

## role
|カラム名|データ型|
|----|----|
|id|int|
|name|varchar|
|created_at|datetime|
|updated_at|datetime|
|deleted_at|datetime|

## label
|カラム名|データ型|
|----|----|
|id|int|
|user_id|int|
|name|varchar|
|created_at|datetime|
|updated_at|datetime|
|deleted_at|datetime|

## task
|カラム名|データ型|
|----|----|
|id|int|
|user_id|int|
|title|varchar|
|detail|text|
|status|tinyint|
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
