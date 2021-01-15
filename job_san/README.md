# JobSanとは
タスクを管理してくれるすごいやつ

# 目次

1. 環境構築
1. メンテナンスモードに関して

## 環境構築

大まかな流れは以下です
1. docker build
1. db migration
1. webpack compile(暫定)
1. こんにちは世界
1. 各種確認

### 1. Docker build

目的：サーバの構築

以下のコマンドを実行してください。

```
$ pwd
> ${リポジトリがある場所}/training/job_san
$ ls
> ... Dockerfile, docker-compose.yml
$ docker-compose up 
> webとdbとselenium_chromeが立ち上がったことを確認してください。
````

### 2. マイグレーション

目的：開発・テスト環境のデータベースのマイグレーション

```
$ docker-compose run web bundle exec rails db:create
> Created database 'job_san_test'
$ docker-compose run web bundle exec rake db:migrate
> 開発環境用のテーブルが生成される。
```

### 3. テーブルスキーマを戻す（暫定対応）

目的：自動で変更された差分を元に戻す

mysql2のバグのため、テーブル定義でutf8mb4のエスケープ文字が扱えないようです。
2で行った`rake db:migrate`でrailsによって自動で変更された差分を元に戻してください。

```
$ git diff
> job_san/db/schema.rb

$ git checkout job_san/db/schema.rb
> 自動で変更された内容を戻す 
```

### 4. webpackerのインストール（暫定対応）

目的：webpackerのインストール

以下のエラー画面が表示された際、この項目を行ってください。

<img width="400" alt="docker-setup" src="docs/readme_images/webpacker_install.png">

webpackerのインストールが正しく行えていないです。

`rails new`のやり方がよくなかったっぽいです。余裕があったら直します。

以下のコマンドを実行してください。
```
$ docker-compose run web bundle exec rails webpacker:install
> Webpacker successfully installed
```

### 5. HELLO WORLD !

お疲れ様でした。 これで環境構築は終わりです。

サーバが立ち上がっていなければ、再度立ち上げてください。

```
$ docker-compose up
> web_1              | * Listening on http://0.0.0.0:3000

ブラウザにアクセスしてください。
```

### 6. 確認方法

#### 動作確認
`docker-compouse up` してサーバを立ち上げてから`http://localhost:80` へアクセスして下さい。

### テスト実行
`docker-compose exec web bundle exec rspec`

## メンテナンスモードに関して

1. メンテナンスモード開始
1. メンテナンスモード終了

### メンテナンスモード開始

```
$ pwd
> ${リポジトリがある場所}/training/job_san
$ ls
> maintenance_manage.sh
$ ./meintenance_manage.sh
> スタートする場合は start、ストップする場合は stop と入力して下さい
$ start
> Maintenance mode changed to start
```

### メンテナンスモード終了

#### shell編
```
$ pwd
> ${リポジトリがある場所}/training/job_san
$ ls
> maintenance_manage.sh
$ ./maintenance_manage.sh
> スタートする場合は start、ストップする場合は stop と入力して下さい
$ stop
> Maintenance mode changed to stop
```

#### Makefile編

1. current directoryの確認
```
$ pwd
> ${リポジトリがある場所}/training/job_san
$ ls
> Makefile
```
2. メンテナンスモード開始

```
$ make maintenance-start
> メンテナンスモードスタート

ブラウザで確認してください
```

3. メンテナンスモード終了

```
$ make maintenance-stop
>　メンテナンスモードフィニッシュ

ブラウザで確認してください
```

## 注意事項

### 1. railsによるdbのマイグレーション関連
`ex: rake db:migrate:redo`

mysql側のバグ？で `utf8mb4のエスケープ文字を扱うことができません`。

railsで生成されたschemaファイルから`_utf8mb4\\'カラム名'\\`のエスケープしている部分を削除してください。（`git diff`で確認できます。）

参考: https://bugs.mysql.com/bug.php?id=100607
