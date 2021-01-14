# Rails研修課題アプリ:タスク管理システム

* Ruby version: 2.7.2
* Rails version: 6.1.0
* Mysql version: 5.6

## アプリを起動する方法
1. Ruby 2.7.2のインストール
```shell
# homebrew, rbenvのインストールをした前提

rbenv install 2.7.2
```

2. MySQL 5.6のインストール
```shell
brew install mysql@5.6
```

3. MySQLのパスを通す
```shell
echo 'export PATH="/usr/local/opt/mysql@5.6/bin:$PATH"' >> ~/.bash_profile
source ~/.bash_profile
```

4. MySQLの起動
```shell
mysql.server start
```

5. MySQLへの接続
```shell
mysql -u yOkuno -p
*パスワードはpassword
```

6. ライブラリ(gem)のインストール
```shell
gem install bundler
cd [プロジェクト(task_management)ルート]
bundle install
```
7. データベースの作成とマイグレーション
```shell
rails db:setup
```

8. タスク管理システムの起動
```shell
rails s
```
9. [localhost:3000](http://localhost:3000/)
   に接続してタスク一覧が表示されたら成功です

## タスク管理システムの概要
* 前提

  タスクの優先順位（低・中・高）、
  及びステータス（未着手・着手・完了）の
  増減は無いものとする


* 画面設計

  1.タスク管理画面
  https://gomockingbird.com/projects/ng0fv2h/4gXVnC

  2.ユーザ登録画面
  https://gomockingbird.com/projects/ng0fv2h/TnMd3U

  3.ログイン画面
  https://gomockingbird.com/projects/ng0fv2h/PduyV7

  4.メンテナンス画面
  https://gomockingbird.com/projects/ng0fv2h/6cwKfd

  ※「1.タスク管理画面」と「2.ユーザ登録画面」はSPA前提


* テーブル設計

  1.権限マスタ

  ・権限区分 UK INT

  ・権限名 VARCHAR

  2.ユーザテーブル

  ・ログインID UK VARCHAR

  ・ユーザ名 VARCHAR

  ・パスワード(暗号化して登録) VARCHAR

  ・権限ID FK BIGINT

  3.ラベルマスタ

  ・ユーザID UK FK BIGINT

  ・ラベル名 UK VARCHAR

  4.タスクテーブル

  ・ユーザID UK FK BIGINT

  ・タスク名 VARCHAR

  ・タスク詳細 VARCHAR

  ・終了期限 DATETIME

  ・ステータス INT (0:未着手 1:着手 2:完了)

  ・優先順位 INT (0:低 1:中 2:高)

  ・作成日時 DATETIME

  5.タスクテーブル-ラベルマスタ紐付テーブル

  ・タスクID UK FK BIGINT

  ・ラベルID UK FK BIGINT
