# todoman

- [アプリケーションの完成イメージ](https://github.com/Fablic/training/blob/f805751a3d26b2f80b8e4d1fcd1befbd2400fa2d/docs/ui_design.png)
- [モデル図](https://github.com/Fablic/training/blob/0d88fcb396dc110865ecef88d3ef4e672aa653b5/docs/data_model.png)

## メンテナンスモードの設定

```
# メンテナンスモードに移行
rails maintenance:on

# メンテナンスモードから復帰
rails maintenance:off
```

## スキーマ定義

### users

|  カラム  |  データ型  |
|----|----|
|  id  |  INT  |
|  name  | VARCHAR |
|  email  | VARCHAR |
|  password  | VARCHAR |
|  created_at  | DATETIME |
|  updated_at  | DATETIME |

### tasks

|  カラム  |  データ型  |
|----|----|
|  id  |  INT  |
|  user_id  | INT |
|  status  | TINYINT |
|  title  | VARCHAR |
|  description  | VARCHAR |
|  priority  | INT |
|  due_date  | DATE |
|  created_at  | DATETIME |
|  updated_at  | DATETIME |

### labels

|  カラム  |  データ型  |
|----|----|
|  id  |  INT  |
|  name  | VARCHAR |
|  user_id  | INT |
|  created_at  | DATETIME |
|  updated_at  | DATETIME |

### task_labels

|  カラム  |  データ型  |
|----|----|
|  id  |  INT  |
|  task_id  | INT |
|  label_id  | INT |
|  created_at  | DATETIME |
|  updated_at  | DATETIME |

