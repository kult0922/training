# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* テーブルスキーマ

|モデル/テーブル|User/users|
|:-:|:-:|
|id|bigint|
|email|password|
|password|varchar(255)|

|モデル/テーブル|Label/labels|
|:-:|:-:|
|id|bigint|
|name|varchar(255)|

|モデル/テーブル|Task/tasks|
|:-:|:-:|
|id|bigint|
|title|varchar(255)|
|description|text|
|due_date|datetime|
|user_id|bigint|
|status|int|

|モデル/テーブル|TaskLabel/task_labels|
|:-:|:-:|
|id|bigint|
|task_id|bigint|
|label_id|bigint|
