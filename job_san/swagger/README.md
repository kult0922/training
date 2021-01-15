# APISpec

注意：swaggerはまだ書いていないです。

## 環境構築

```
$ pwd
> xxxx/training/job_san/job_san_api_spec

$ ls
> docker-compose.yml	swagger.yaml

$ docker-compose up
> CHECK localhost:80 ON BROWSER
```

### swagger-editorを使う (option)
```
$ docker pull swaggerapi/swagger-editor
$ docker run -p 80:8080 swaggerapi/swagger-ui
> CHECK localhost:80 ON BROWSER
```
